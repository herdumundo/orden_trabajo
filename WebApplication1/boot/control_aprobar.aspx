<%@ Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %> 
<% @Import Namespace="System.Net.Mail" %> 
    <%   
         if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }
        Contacts Actividad;
        String conn = Global.sap_conn;
        String con_gmaehara = Global.gm_conn;
        SqlConnection conex_gmehara = new SqlConnection(con_gmaehara);
        SqlConnection cnn_sap = new SqlConnection(conn);
        String id_actividad = "";
        string clgcode="";
        Company empresa = new Company();
        ServiceCalls OT;
        //Contacts Actividad;
        String id_ot = Request.Params["id"];
        //String comentario=Request.Params["txt_comentario"];
        String nombre_usuario = Session["nombre_usuario_gm"].ToString();

        String id_usuario =Session["id_usuario"].ToString();
        String descripcion_ot =Request.Params["descripcion"].ToString();
        String detalle =Request.Params["detalle"].ToString();
        String mail =Session["correo"].ToString();
        String mail_1 = "";
        String mail_2 = "";
        SqlCommand rs;
        string fecha_noti = "";
        SqlDataReader dr;
        empresa.Server = Global.server;
        empresa.CompanyDB = Global.companydb;
        switch (Global.sap_dbservertype)
        {
            case "2014":
                empresa.DbServerType = BoDataServerTypes.dst_MSSQL2014;
                break; };
        empresa.DbUserName = Global.DBuserName;
        empresa.DbPassword = Global.DBpassword;
        empresa.UserName = Session["usuario"].ToString();
        empresa.Password =Session["pass"].ToString();

        cnn_sap.Open();

        rs = new SqlCommand(" select *,convert(varchar,GETDATE(),103) as fecha_noti from oclg where parentid="+id_ot+"and closed='N'", cnn_sap);

        dr = rs.ExecuteReader();
        while (dr.Read())
        {   id_actividad = dr["clgcode"].ToString();
            fecha_noti= dr["fecha_noti"].ToString();
        }
        dr.Close();

        try
        {
            if (empresa.Connected == false)
            {

                if (empresa.Connect() != 0)
                {
                    String ERROR1=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());

                        %><%=ERROR1%><%
  %>   <script>
                                        swal({
                                        title: "<%=ERROR1%>" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                                
                                      </script>       
                                    <%    
                                               

                }
                                      else
                                                   {

                                         

 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    empresa.StartTransaction();
                   Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                   Actividad.GetByKey(int.Parse(id_actividad));
                   Actividad.Closed = BoYesNoEnum.tYES;
                     Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                           
                   if (Actividad.Update() != 0)
                   {
                    String error2=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                          %><%=error2%>    <script>
                                        swal({
                                        title: "<%=error2%>" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                                
                                      </script>       
                                    <%    
                    empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                   return;
                   }


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


                OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                OT.GetByKey(int.Parse(id_ot));
                Actividad.CardCode ="P44444401";
                Actividad.ActivityType = -1;
                Actividad.Activity = BoActivities.cn_Other;
                Actividad.Details = "APROBADA";
                Actividad.Notes = "OT APROBADA";
                Actividad.EndDuedate = DateTime.Now.Date;
                Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                Actividad.Closed = BoYesNoEnum.tYES;
              if (Actividad.Add() != 0)
                                              {
                 String error2=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                             %><%=error2%> 2<%

                                                     %>   <script>
                                        swal({
                                        title: "<%=error2%>" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                                
                                      </script>       
                                    <%    



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
                                                            String error1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                                                        };
                                                                            }





                OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                OT.GetByKey(int.Parse(id_ot));
                Actividad.CardCode ="P44444401";
                Actividad.ActivityType = -1;
                Actividad.Activity = BoActivities.cn_Other;
                Actividad.Details = "PENDIENTE";
                Actividad.Notes = "PENDIENTE APROBACION MANTENIMIENTO";
                Actividad.EndDuedate = DateTime.Now.Date;
                Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                 
              if (Actividad.Add() != 0)
                                              {
                 String error2=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                             %><%=error2%> 2<%

                                                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                            return;
                                                        }
                                                        else { 

                                                        clgcode = empresa.GetNewObjectKey();
                                                        OT.Activities.Add();
                                                        OT.Activities.ActivityCode = int.Parse(clgcode);
                                                        OT.Resolution = "";
                                                        OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                                                        OT.Activities.UserFields.Fields.Item("U_usuario").Value =nombre_usuario;
                                                        OT.Status = 2;
                                                       
                                                        if (OT.Update()!=0)
                                                        {
                                                            String error1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

 %>                                     <script>
                                        swal({
                                        title: "<%=error1%>" , 
                                        confirmButtonText: "CERRAR" 
                                        });
                                        $.preloader.stop();
                                      </script>       
                                    <%    
                                                        };
                                                            }
                                                              };
                                                empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                                                               
 %>                                     <script>
                                        swal({
                                        title: "REGISTRADO CON EXITO" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                        traer_informe_ot_admin();
                                        </script>       
                                    <%   
                                              SmtpClient correo = new SmtpClient();
                correo.Port = 587;
                correo.Host = "smtp.gmail.com";
                correo.EnableSsl = true;
                correo.DeliveryMethod = SmtpDeliveryMethod.Network;
                correo.UseDefaultCredentials = false;
                correo.Credentials = new System.Net.NetworkCredential("reportes.vmiis@gmail.com", "gm$12345622");

                //MailMessage mm = new MailMessage("reportes.vmiis@gmail.com", "felix.gaona@yemita.com.py", "Error Interface CAST", msj);
                MailMessage mm = new MailMessage();
                mm.From = new MailAddress("reportes.vmiis@gmail.com");
                String[] mail_arr = mail.Split('-');

                                mail_1=mail_arr[0];
                                mail_2=mail_arr[1];
                                mm.To.Add(mail_1);
                                mm.To.Add(mail_2);
                mm.Subject = "PEDIDO DE TRABAJO";
                mm.Body = "SOLICITUD NRO: "+id_ot+" \n\n APROBADO POR: "+nombre_usuario+" \n\n DESCRIPCION: "+descripcion_ot+"\n\n DETALLE: "+detalle;

                correo.Send(mm); 
  
                                                };
                                    
                                                          }

                                                          catch(Exception ex)
                                                          {
                                                              String ERROR1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                                                    %>   <%=ex%>  +++++++++   <%=id_ot%> <%    
                                                        if(empresa.InTransaction)
                                                            {
                                                            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                            };
                                                         %>
                              <script>
                                        swal({
                                        title: "<%=ex%>" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                        traer_informe_ot_admin();
                                        </script>       
                                                  <%
                                                         }
                                                          finally
                                                          {
                                                              if (empresa.Connected)
                                                              {
                                   
                                                                  empresa.Disconnect();
                                                              };

                                                          };

                     
%>
   