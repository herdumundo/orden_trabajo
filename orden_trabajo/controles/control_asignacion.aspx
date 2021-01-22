<%@ Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
<% @Import Namespace="Newtonsoft.Json.Linq" %>
  
    <%     if (Session["nombre_usuario"] == null)
        {
            Response.Redirect("login.aspx");

        }

        String elemento = "";
        String elemento_proveedor = "";
        String conn = Global.sap_conn;
        String operario = Request.Params["operario"];
        String nro_ot = Request.Params["nro_ot"];
        String nota=Request.Params["nota"];
        String id_proveedor = "";
        String valor = "";
        String nombre_proveedor = "";
        String nombre_usuario = Session["nombre_usuario_gm"].ToString();
        String id_usuario = Session["id_usuario"].ToString();
        SqlConnection cnn_sap = new SqlConnection(conn);
        SqlCommand rs, rs2;
        SqlDataReader dr, dr2;
        String clgcode = "";
        String user_name = "";
        Company empresa = new Company();
        UserTable usuario;
        UserTable usuario2;
        Contacts Actividad;
        string cardcode = "";
        String tipo_mensaje = "";
        String mensaje_resultado = "";
        ServiceCalls OT;
        String id_actividad = "";
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
        String nota_recuperada = "";
        rs = new SqlCommand(" select * from oclg where parentid=" + nro_ot + "and closed='N'", cnn_sap);

        dr = rs.ExecuteReader();
        while (dr.Read())
        {
            id_actividad = dr["clgcode"].ToString();
            cardcode = dr["cardcode"].ToString();
            nota_recuperada=dr["notes"].ToString();

        }
        dr.Close();
        String[] elementos_operario = operario.Split(',');
        String nota_final = "";
     

        try
        {
               if (nota.Length == 0)
        {
            nota_final = nota_recuperada;

        }

        else
        {
            nota_final = nota_recuperada + "\n" + nombre_usuario + ":" + nota;

        }

            if (empresa.Connected == false)
            {

                if (empresa.Connect() != 0)
                {
                    tipo_mensaje = "1";
                    mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                }

                else
                {
                    empresa.StartTransaction();
                    if (operario.Length > 0)
                    {

                        GeneralService oGeneralService;
                        GeneralData oGeneralData;
                        GeneralData oChild;
                        GeneralDataCollection oChildren;
                        CompanyService oCompService;
                        oCompService = empresa.GetCompanyService();

                        oGeneralService = oCompService.GetGeneralService("OTOPCAB");
                        oGeneralData = (SAPbobsCOM.GeneralData)oGeneralService.GetDataInterface(GeneralServiceDataInterfaces.gsGeneralData);
                        //Setting Data to Master Data Table Fields
                        oGeneralData.SetProperty("Code", nro_ot.ToString());

                        for (int i = 0; i < elementos_operario.Length; i++)
                        {
                            elemento = elementos_operario[i];
                            rs = new SqlCommand("select (firstName+' '+lastName) as nombre from ohem where empID='" + elemento + "'", cnn_sap);
                            dr = rs.ExecuteReader();
                            while (dr.Read())
                            {
                                user_name = dr["nombre"].ToString();

                            }
                            dr.Close();
                            //Setting Data to Child Table Fields
                            oChildren = oGeneralData.Child("OT_OP");
                            oChild = oChildren.Add();
                            oChild.SetProperty("U_Id_Operario", elemento);
                            oChild.SetProperty("U_Nombre_Operario", user_name);
                            //Attempt to Add the Record
                        }
                        oGeneralService.Add(oGeneralData);
                    }

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
                    OT.GetByKey(int.Parse(nro_ot));

                    Actividad.CardCode = cardcode;
                    Actividad.ActivityType = -1;
                    Actividad.Activity = BoActivities.cn_Other;
                    Actividad.Details = "ASIGNACION REALIZADA";
                    Actividad.Notes = "ASIGNACION REALIZADA";
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
                    OT.GetByKey(int.Parse(nro_ot));
                    Actividad.CardCode = cardcode;
                    Actividad.ActivityType = -1;
                    Actividad.Activity = BoActivities.cn_Other;
                    Actividad.Details = "PENDIENTE DE RESOLUCION";
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
                empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                tipo_mensaje = "0";
                mensaje_resultado = "REGISTRADO CON EXITO";

            };
            /*  if (empresa.InTransaction) {
                   empresa.EndTransaction(SAPbobsCOM.BoWfTransOpt.wf_Commit);
               } */
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


        cnn_sap.Close();
        JObject ob = new JObject();
        ob = new JObject();
        ob.Add("tipo_mensaje", tipo_mensaje);
        ob.Add("mensaje_resultado", mensaje_resultado);
        Response.Write(ob);
        Response.ContentType = "application/json; charset=utf-8";
        Response.End();

                                                                   %>

   
