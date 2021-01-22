<%@ Page Language="C#" AutoEventWireup="true" %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %> 
<% @Import Namespace="System.Net.Mail" %> 
<% @Import Namespace="Newtonsoft.Json.Linq" %> 
<% @Import Namespace="Newtonsoft.Json" %> 
    <%  
        Contacts Actividad;
        String conn             = Global.sap_conn;
        String conn_gm          = Global.gm_conn;
        SqlConnection cnn_sap   = new SqlConnection(conn);
        SqlConnection cnn_gm    = new SqlConnection(conn_gm);

        Company empresa         = new Company();
        ServiceCalls OT;

        String id_ot            = Request.Params["id"];
        String cbox_terc        = Request.Params["cbox_terc"];
        String cbox_encargado   = Request.Params["cbox_encargado"];
        String descripcion      = Request.Params["descripcion"];
        String detalle          = Request.Params["detalle"];
        String nota             = Request.Params["nota"];
        String tipo_registro    = Request.Params["tipo_registro"];
        String operarios_log    = Request.Params["operarios_logistica"];

        String nombre_usuario   = Session["nombre_usuario_gm"].ToString();
        String id_usuario       = Session["id_usuario"].ToString();
        String perfil           = Session["perfil"].ToString();
        String area             = Session["area"].ToString();

        SqlCommand rs, rs2;
        SqlDataReader dr, dr2;
        String id_actividad                     = "";
        String clgcode                          = "";
        String condicion_terc                   = "";
        String mensaje_pendiente                = "";
        String mensaje_aprobado                 = "";
        String usuario_encargado_mantenimiento  = "";
        String nombre_condicion                 = "";
        String id_usuario_condicion             = "";
        String nota_recuperada                  = "";
        String cardcode                         = "";
        String mail                             = "";
        String nota_final                       = "";
        String tipo_mensaje                     = "";
        String mensaje_resultado                = "";
        int estado_orden                        = 0;

        empresa.Server = Global.server;
        empresa.CompanyDB = Global.companydb;
        switch (Global.sap_dbservertype)
        {
            case "2014":
                empresa.DbServerType = BoDataServerTypes.dst_MSSQL2014;
                break;
        };
        empresa.DbUserName = Global.DBuserName;
        empresa.DbPassword = Global.DBpassword;
        empresa.UserName = Session["usuario"].ToString();
        empresa.Password = Session["pass"].ToString();

        cnn_sap.Open();
        cnn_gm.Open();


        if (tipo_registro.Equals("LOG"))
        {
            condicion_terc          = "NO";
            estado_orden            = 4;
            id_usuario_condicion    = id_usuario;
            nombre_condicion        = nombre_usuario;
            mensaje_pendiente       = "PENDIENTE DE RESOLUCION";
            mensaje_aprobado        = "OT APROBADA JEFE LOGISTICA";

        }
        else if (tipo_registro.Equals("MANT"))
        {
            if (cbox_terc.Length > 0)
            {
                condicion_terc = "SI";
                mensaje_pendiente = "PENDIENTE DE RESOLUCION";
                mensaje_aprobado = "OT APROBADA JEFE MANTENIMIENTO";
                estado_orden = 4;
                id_usuario_condicion = cbox_encargado;
                nombre_condicion = usuario_encargado_mantenimiento;

            }
            else
            {
                condicion_terc = "NO";

                mensaje_pendiente = "PENDIENTE ASIGNACION OPERARIOS";
                mensaje_aprobado = "OT APROBADA JEFE MANTENIMIENTO";
                estado_orden = 3;
                id_usuario_condicion = id_usuario;
                nombre_condicion = nombre_usuario;

            }
            rs2 = new SqlCommand(" select * from ot_usuario with(nolock) where cod_usuario=" + cbox_encargado + "", cnn_gm);
            dr2 = rs2.ExecuteReader();
            while (dr2.Read())
            {
                mail = dr2["correo"].ToString();
                usuario_encargado_mantenimiento= dr2["nombre"].ToString();
            }
            dr2.Close();

        }






        rs = new SqlCommand(" select * from oclg with(nolock) where parentid=" + id_ot + "and closed='N'", cnn_sap);



        dr = rs.ExecuteReader();
        while (dr.Read())
        {
            id_actividad = dr["clgcode"].ToString();
            cardcode = dr["cardcode"].ToString();
            nota_recuperada=dr["notes"].ToString();
        }
        dr.Close();


        if (nota.Length == 0)
        {
            nota_final =nota_recuperada;
        }

        else
        {
            nota_final = nota_recuperada+"\n"+nombre_usuario + ": " + nota;

        }


        try
        {
            if (empresa.Connected == false)
            {

                if (empresa.Connect() != 0)
                {
                    tipo_mensaje = "1";
                    mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());



                }
                else
                {
                    if (tipo_registro.Equals("MANT"))
                    {


                        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        empresa.StartTransaction();
                        Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                        Actividad.GetByKey(int.Parse(id_actividad));
                        Actividad.Closed = BoYesNoEnum.tYES;
                        Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                        Actividad.EndDuedate = DateTime.Now.Date;
                        if (Actividad.Update() != 0)
                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                            return;
                        }
                        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                        Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                        OT.GetByKey(int.Parse(id_ot));
                        Actividad.CardCode = cardcode;
                        Actividad.ActivityType = -1;
                        Actividad.Activity = BoActivities.cn_Other;
                        Actividad.Details = "APROBADA";
                        Actividad.Notes = mensaje_aprobado;
                        Actividad.EndDuedate = DateTime.Now.Date;
                        Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                        Actividad.Closed = BoYesNoEnum.tYES;
                        if (Actividad.Add() != 0)
                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                            return;
                        }
                        else
                        {
                            clgcode = empresa.GetNewObjectKey();
                            OT.Activities.Add();
                            OT.Activities.ActivityCode = int.Parse(clgcode);
                            OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario_condicion);
                            OT.Activities.UserFields.Fields.Item("U_usuario").Value = nombre_condicion;

                            if (OT.Update() != 0)

                            {
                                tipo_mensaje = "1";
                                mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                            };
                        }

                        OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                        Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                        OT.GetByKey(int.Parse(id_ot));
                        Actividad.CardCode = cardcode;
                        Actividad.ActivityType = -1;
                        Actividad.Activity = BoActivities.cn_Other;
                        Actividad.Details = mensaje_pendiente;
                        //Actividad.SalesEmployee =int.Parse(cbox_encargado);
                        Actividad.UserFields.Fields.Item("U_Id_Asignado").Value = int.Parse(cbox_encargado);
                        Actividad.Notes = nota_final.ToUpper();
                        Actividad.EndDuedate = DateTime.Now.Date;
                        Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));

                        if (Actividad.Add() != 0)
                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                            return;
                        }

                        else
                        {
                            clgcode = empresa.GetNewObjectKey();
                            OT.Activities.Add();
                            OT.Activities.ActivityCode = int.Parse(clgcode);
                            OT.Resolution = "";
                            OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario_condicion);
                            OT.Activities.UserFields.Fields.Item("U_usuario").Value = nombre_condicion;
                            OT.UserFields.Fields.Item("U_ot_tercer").Value = condicion_terc;
                            OT.UserFields.Fields.Item("U_prov_terc").Value = cbox_terc;
                            OT.Status = estado_orden;

                            if (OT.Update() != 0)

                            {
                                tipo_mensaje = "1";
                                mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                            }

                        }
                    } // FIN IF MANT


                    else if (tipo_registro.Equals("LOG"))
                    {


                        empresa.StartTransaction();


                        GeneralService oGeneralService;
                        GeneralData oGeneralData;
                        GeneralData oChild;
                        GeneralDataCollection oChildren;
                        CompanyService oCompService;
                        oCompService = empresa.GetCompanyService();

                        oGeneralService = oCompService.GetGeneralService("OTOPCAB");
                        oGeneralData = (SAPbobsCOM.GeneralData)oGeneralService.GetDataInterface(GeneralServiceDataInterfaces.gsGeneralData);
                        //Setting Data to Master Data Table Fields
                        oGeneralData.SetProperty("Code", id_ot.ToString());
                        String[] elementos_operario = operarios_log.Split(',');
                        String elemento = "";
                        String nombre_operario = "";
                        String id_operario = "";
                        for (int i = 0; i < elementos_operario.Length; i++)
                        {
                            elemento = elementos_operario[i];
                            String[] sub_valores_array = elemento.Split('_');
                            id_operario = sub_valores_array[0];
                            nombre_operario = sub_valores_array[1];
                            //Setting Data to Child Table Fields
                            oChildren = oGeneralData.Child("OT_OP");
                            oChild = oChildren.Add();
                            oChild.SetProperty("U_Id_Operario", id_operario);
                            oChild.SetProperty("U_Nombre_Operario", nombre_operario);
                            //Attempt to Add the Record
                        }

                        oGeneralService.Add(oGeneralData);


                        Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                        Actividad.GetByKey(int.Parse(id_actividad));
                        Actividad.Closed = BoYesNoEnum.tYES;
                        Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                        Actividad.EndDuedate = DateTime.Now.Date;

                        if (Actividad.Update() != 0)
                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                            return;
                        }

                        OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                        Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                        OT.GetByKey(int.Parse(id_ot));

                        Actividad.CardCode = cardcode;
                        Actividad.ActivityType = -1;
                        Actividad.Activity = BoActivities.cn_Other;
                        Actividad.Details = "APROBADO";
                        Actividad.Notes = mensaje_aprobado;
                        Actividad.EndDuedate = DateTime.Now.Date;
                        Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                        Actividad.Closed = BoYesNoEnum.tYES;
                        if (Actividad.Add() != 0)
                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                            return;
                        }

                        else
                        {

                            clgcode = empresa.GetNewObjectKey();
                            OT.Activities.Add();
                            OT.Activities.ActivityCode = int.Parse(clgcode);
                            OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                            OT.Activities.UserFields.Fields.Item("U_usuario").Value = nombre_usuario;

                            if (OT.Update() != 0)

                            {
                                tipo_mensaje = "1";
                                mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            };
                        }

                        OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                        Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                        OT.GetByKey(int.Parse(id_ot));
                        Actividad.CardCode = cardcode;
                        Actividad.ActivityType = -1;
                        Actividad.Activity = BoActivities.cn_Other;
                        Actividad.Details = "PENDIENTE DE RESOLUCION";
                        Actividad.UserFields.Fields.Item("U_Id_Asignado").Value = int.Parse(id_usuario);
                        Actividad.Notes =  nota_final.ToUpper();
                        Actividad.EndDuedate = DateTime.Now.Date;
                        Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));

                        if (Actividad.Add() != 0)
                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                            return;
                        }
                        else
                        {

                            clgcode = empresa.GetNewObjectKey();

                            OT.Activities.Add();
                            OT.Activities.ActivityCode = int.Parse(clgcode);
                            OT.Resolution = "";
                            // OT.Subject = detalle_anterior + "\n        |FECHA DE INICIO:"+ fecha_inicio + "  |FECHA FINAL:" + fecha_fin;
                            OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                            OT.Activities.UserFields.Fields.Item("U_usuario").Value = nombre_usuario;
                            OT.Status = 4;

                            if (OT.Update() != 0)

                            {
                                tipo_mensaje = "1";
                                mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                            };
                        }
                    }
                };

                empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                // empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                tipo_mensaje = "0";
                mensaje_resultado = "REGISTRADO CON EXITO";
                /*  SmtpClient correo = new SmtpClient();
                  correo.Port = 587;
                  correo.Host = "smtp.gmail.com";
                  correo.EnableSsl = true;
                  correo.DeliveryMethod = SmtpDeliveryMethod.Network;
                  correo.UseDefaultCredentials = false;
                  correo.Credentials = new System.Net.NetworkCredential("reportes.vmiis@gmail.com", "gm$123456789");
                  String mail_1 = "";
                  String mail_2 = "";

                  //MailMessage mm = new MailMessage("reportes.vmiis@gmail.com", "felix.gaona@yemita.com.py", "Error Interface CAST", msj);
                  MailMessage mm = new MailMessage();
                  mm.From = new MailAddress("reportes.vmiis@gmail.com");

                  if (mail.Contains("-"))
                  {
                      String[] mail_arr = mail.Split('-');

                      mail_1=mail_arr[0];
                      mail_2=mail_arr[1];
                      mm.To.Add(mail_1);
                      mm.To.Add(mail_2);
                  }
                  else
                  {
                      mm.To.Add(mail);
                  }
                  mm.Subject = "PEDIDO DE TRABAJO";
                  mm.Body = "SOLICITUD NRO: " + id_ot + " \n\n APROBADO Y ASIGNADO  POR: " + nombre_usuario + "\n\n DESCRIPCION: " + descripcion + "\n\n DETALLE: " + detalle;
                 correo.Send(mm); */

            };

        }

        catch (Exception ex)
        {

            if (empresa.InTransaction)
            {
                empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
            };
            tipo_mensaje = "1";
            mensaje_resultado = ex.ToString();

        }
        finally
        {
            if (empresa.Connected)
            {
                empresa.Disconnect();
            };
            cnn_sap.Close();
            cnn_gm.Close();
            JObject ob = new JObject();
            ob = new JObject();
            ob.Add("tipo_mensaje", tipo_mensaje);
            ob.Add("mensaje_resultado", mensaje_resultado);
            Response.Write(ob);
            Response.ContentType = "application/json; charset=utf-8";
            Response.End();

        };
         %>
   