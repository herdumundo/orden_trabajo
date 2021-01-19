<%@ Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %> 
<% @Import Namespace="Newtonsoft.Json.Linq" %>

    <%
        if (Session["nombre_usuario"] == null)
        {
            Response.Redirect("login.aspx");

        }

        Contacts Actividad;
        String conn = Global.sap_conn;
        String mensaje_resultado = null;
        String tipo_mensaje = null;
        SqlConnection cnn_sap = new SqlConnection(conn);
        String id_actividad = "";
        string clgcode="";
        Company empresa = new Company();
        ServiceCalls OT;
        //Contacts Actividad;
        String id_ot = Request.Params["id"];
        //   String comentario=Request.Params["txt_comentario"];
        String nota=Request.Params["motivo"];
        String nombre_usuario = Session["nombre_usuario_gm"].ToString();
        String id_usuario =Session["id_usuario"].ToString();
        SqlCommand rs;
        SqlDataReader dr;
        String nota_recuperada = "";

        String valor = "";
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
        empresa.Password =Session["pass"].ToString();

        cnn_sap.Open();

        rs = new SqlCommand(" select * from oclg where parentid="+id_ot+"and closed='N'", cnn_sap);
        String cardcode = "";
        dr = rs.ExecuteReader();
        while (dr.Read())
        {   id_actividad = dr["clgcode"].ToString();
            cardcode= dr["cardcode"].ToString();
            nota_recuperada=dr["notes"].ToString();
        }
        dr.Close();

        try
        {


            if (empresa.Connected == false)
            {

                if (empresa.Connect() != 0)
                {
                    String ERROR1=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                    valor = ERROR1;
                        %><%=valor%> <%  
                                                 }
                                                 else
                                                 {



                                                     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                     empresa.StartTransaction();
                                                     Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                                                     Actividad.GetByKey(int.Parse(id_actividad));
                                                     Actividad.Closed = BoYesNoEnum.tYES;
                                                     Actividad.EndDuedate = DateTime.Now.Date;

                                                     Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));

                                                     if (Actividad.Update() != 0)
                                                     {
                                                         mensaje_resultado=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                                                         tipo_mensaje = "0";

                                                         empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                         return;
                                                     }


                                                     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


                                                     OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                                                     Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                                                     OT.GetByKey(int.Parse(id_ot));
                                                     Actividad.CardCode =cardcode;
                                                     Actividad.ActivityType = -1;
                                                     Actividad.Activity = BoActivities.cn_Other;
                                                     Actividad.Details ="RESOLUCION RECHAZADA";
                                                     Actividad.Notes = "RESOLUCION RECHAZADA";
                                                     Actividad.EndDuedate = DateTime.Now.Date;
                                                     Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                                                     Actividad.Closed = BoYesNoEnum.tYES;
                                                     if (Actividad.Add() != 0)
                                                     {
                                                         mensaje_resultado=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                                                         tipo_mensaje = "0";

                                                         empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                         return;
                                                     }

                                                     else {

                                                         clgcode = empresa.GetNewObjectKey();

                                                         OT.Activities.Add();
                                                         OT.Activities.ActivityCode = int.Parse(clgcode);

                                                         OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                                                         OT.Activities.UserFields.Fields.Item("U_usuario").Value =nombre_usuario;

                                                         if (OT.Update()!=0)

                                                         {
                                                             mensaje_resultado=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                                                             tipo_mensaje = "0";

                                                         };
                                                     }





                                                     OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                                                     Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                                                     OT.GetByKey(int.Parse(id_ot));
                                                     Actividad.CardCode =cardcode;
                                                     Actividad.ActivityType = -1;
                                                     Actividad.Activity = BoActivities.cn_Other;
                                                     Actividad.Details =  "PENDIENTE RESOLUCION";
                                                     Actividad.Notes = nota_recuperada + "\n" + nombre_usuario + ":" + nota;
                                                     Actividad.EndDuedate = DateTime.Now.Date;
                                                     Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));

                                                     if (Actividad.Add() != 0)
                                                     {
                                                         mensaje_resultado=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                                                         tipo_mensaje = "0";

                                                         empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                         return;
                                                     }
                                                     else {

                                                         clgcode = empresa.GetNewObjectKey();

                                                         OT.Activities.Add();
                                                         OT.Activities.ActivityCode = int.Parse(clgcode);
                                                         OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                                                         OT.Activities.UserFields.Fields.Item("U_usuario").Value =nombre_usuario;
                                                         OT.Status = 4;
                                                         if (OT.Update()!=0)
                                                         {
                                                             mensaje_resultado=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                                                             tipo_mensaje = "0";

                                                         };
                                                     }
                                                 };
                                                 empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                                                 mensaje_resultado = "REGISTRO CANCELADO";
                                                 tipo_mensaje = "1";
                                             };

                                         }

                                         catch(Exception ex)
                                         {

                                             if(empresa.InTransaction)
                                             {
                                                 empresa.EndTransaction(BoWfTransOpt.wf_RollBack);

                                             };
                                             mensaje_resultado=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                                                 tipo_mensaje = "0";

                                         }
                                         finally
                                         {
                                             if (empresa.Connected)
                                             {
                                                 empresa.Disconnect();
                                             };


                                         };
                                         cnn_sap.Close();

                                         JObject ob = new JObject();
                                         ob = new JObject();
                                         ob.Add("tipo_mensaje", tipo_mensaje);
                                         ob.Add("mensaje_resultado", mensaje_resultado);
                                         Response.Write(ob);
                                         Response.ContentType = "application/json; charset=utf-8";
                                         Response.End();
                      %>
   