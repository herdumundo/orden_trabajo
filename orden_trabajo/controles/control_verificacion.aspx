<%@ Page Language="C#" AutoEventWireup="true" %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %> 
<% @Import Namespace="Newtonsoft.Json.Linq" %> 

    <%    
       
            if (Session["nombre_usuario"] == null)
            {
                Response.Redirect("login.aspx");

            }
            Contacts Actividad;
            String conn = Global.sap_conn;
            String nota=Request.Params["nota"];
            SqlConnection cnn_sap = new SqlConnection(conn);
            String id_actividad = "";
            string clgcode = "";
            Company empresa = new Company();
            ServiceCalls OT;
            //Contacts Actividad;
            String id_ot = Request.Params["id"];
            String comentario = Request.Params["txt_comentario"];
            String nombre_usuario = Session["nombre_usuario_gm"].ToString();
            String id_usuario = Session["id_usuario"].ToString();
            SqlCommand rs;
            SqlDataReader dr;
            String tipo_mensaje = "";
            String mensaje_resultado = "";
            String perfil = Session["perfil"].ToString();
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
            String valor = "";
            String nota_recuperada = "";
            cnn_sap.Open();
            String cardcode = "";
            String nota_final = "";
            rs = new SqlCommand(" select * from oclg with(nolock) where parentid=" + id_ot + "and closed='N'", cnn_sap);

            dr = rs.ExecuteReader();
            while (dr.Read())
            {
                id_actividad = dr["clgcode"].ToString();
                cardcode = dr["cardcode"].ToString();
                nota_recuperada = dr["notes"].ToString();
            }
            dr.Close();

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
                        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        empresa.StartTransaction();
                        Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                        Actividad.GetByKey(int.Parse(id_actividad));
                        Actividad.Closed = BoYesNoEnum.tYES;

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
                        Actividad.Details = "VERIFICACION APROBADA";
                        Actividad.Notes =    nota_final.ToUpper();
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

                            OT.Status = 6;

                            if (OT.Update() != 0)

                            {
                                String error1 = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                            };
                        }
                    };
                    empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                    tipo_mensaje = "0";
                    mensaje_resultado = "REGISTRADO CON EXITO";

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
                JObject ob = new JObject();
                ob = new JObject();
                ob.Add("tipo_mensaje", tipo_mensaje);
                ob.Add("mensaje_resultado", mensaje_resultado);
                Response.Write(ob);
                Response.ContentType = "application/json; charset=utf-8";
                Response.End();
            };
                    %>
   