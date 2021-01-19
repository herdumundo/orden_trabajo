<%@ Page Language="C#" AutoEventWireup="true" %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %> 
<% @Import Namespace="System.Net.Mail" %> 
<% @Import Namespace="Newtonsoft.Json.Linq" %> 
<% @Import Namespace="Newtonsoft.Json" %> 
    <%     if (Session["nombre_usuario"] == null)
        {
            Response.Redirect("login.aspx");

        }
        Contacts Actividad;
        String conn = Global.sap_conn;
        String conn_gm = Global.gm_conn;
        SqlConnection cnn_sap = new SqlConnection(conn);
        SqlConnection cnn_gm = new SqlConnection(conn_gm);
        String id_actividad = "";
        string clgcode = "";
        Company empresa = new Company();
        ServiceCalls OT;
        String cbox_encargado = Request.Params["cbox_encargado"];
        String proveedor = Request.Params["combo_proveedor"];
        String condicion = ""; ;
        //Contacts Actividad;
        String id_ot = Request.Params["id"];
        String descripcion = Request.Params["descripcion"];
        String nota = Request.Params["nota"];
        String detalle = Request.Params["detalle"];
        String nombre_usuario = Session["nombre_usuario_gm"].ToString();
        String comentario = Request.Params["txt_comentario"];
        String id_usuario = Session["id_usuario"].ToString();
        SqlCommand rs, rs2;
        String perfil = Session["perfil"].ToString();
        String area = Session["area"].ToString();
        String mensaje_pendiente = "";
        String mensaje_aprobado = "";
        int estado_orden = 0;
        String usuario_encargado_mantenimiento = "";
        String nombre_condicion = "";
        String id_usuario_condicion = "";
        SqlDataReader dr, dr2;
        String nota_recuperada = "";
        string cardcode = "";
        String mail = "";
        String valor = "";
        String nota_final = "";
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
        String tipo_mensaje = "";
        String mensaje_resultado = "";
        cnn_sap.Open();
        cnn_gm.Open();

        rs2 = new SqlCommand(" select * from ot_usuario with(nolock) where cod_usuario=" + cbox_encargado + "", cnn_gm);
        dr2 = rs2.ExecuteReader();
        while (dr2.Read())
        {
            mail = dr2["correo"].ToString();
            usuario_encargado_mantenimiento= dr2["nombre"].ToString();
        }
        dr2.Close();
        rs = new SqlCommand(" select * from oclg with(nolock) where parentid=" + id_ot + "and closed='N'", cnn_sap);


        if (proveedor.Length > 0)
        {
            condicion = "SI";
            mensaje_pendiente = "PENDIENTE DE RESOLUCION";
            mensaje_aprobado = "OT APROBADA JEFE MANTENIMIENTO";
            estado_orden = 4;
            id_usuario_condicion = cbox_encargado;
            nombre_condicion = usuario_encargado_mantenimiento;

        }
        else
        {
            condicion = "NO";

            mensaje_pendiente = "PENDIENTE ASIGNACION OPERARIOS";
            mensaje_aprobado = "OT APROBADA JEFE MANTENIMIENTO";
            estado_orden = 3;
            id_usuario_condicion = id_usuario;
            nombre_condicion = nombre_usuario;

        }
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


        //////////////////////////////////////////////////////////////////////////////////////////////////
        ///
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
                        OT.UserFields.Fields.Item("U_ot_tercer").Value = condicion;
                        OT.UserFields.Fields.Item("U_prov_terc").Value = proveedor;
                        OT.Status = estado_orden;

                        if (OT.Update() != 0)

                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                        };
                    }
                };

                empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                tipo_mensaje = "0";
                mensaje_resultado = "REGISTRADO CON EXITO";
                SmtpClient correo = new SmtpClient();
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
                correo.Send(mm);

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
   