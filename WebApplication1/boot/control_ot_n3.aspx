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
    Company empresa = new Company();
    ServiceCalls OT;
    Contacts Actividad;
    string clgcode="";
    String nro_ot;
    //String nombre= Request.Params["txt_nombre"];
    //String ruc= Request.Params["txt_ruc"];
        String id_categoria= Request.Params["id_categoria"];

    String descripcion= Request.Params["description"];
    String origen= Request.Params["cbox_origen"];
    String maquina=Request.Params["cbox_maquina"];
    String tipo_problema= Request.Params["cbox_tipo_problem"];
    String problema= Request.Params["txt_problema"];
    String id_usuario =Session["id_usuario"].ToString();
    String nombre_usuario = Session["nombre_usuario_gm"].ToString();
   // String mail= Session["correo"].ToString();

    if (string.IsNullOrEmpty(descripcion.Trim()) || string.IsNullOrEmpty(origen)|| string.IsNullOrEmpty(tipo_problema)|| string.IsNullOrEmpty(maquina)|| string.IsNullOrEmpty(problema) )
    {
        %>   <script>              
            
                swal({
                    
                title: "ERROR COMPLETE TODOS LOS CAMPOS" , 
               
                confirmButtonText: "CERRAR" 
                 });

   $.preloader.stop();
                    </script>       
        <%    

            }

            else {



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



                try
                {
                    if (empresa.Connected == false)
                    {
                       if (empresa.Connect() != 0)
                        {
                            String ERROR1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                        %><%=ERROR1%>  error1 <%


                                                       %>   <script>
                swal({
                title: "<%=ERROR1%>" , 
                confirmButtonText: "CERRAR" 
                 });
                    $.preloader.stop();
                        </script>       <%  
                                                  }

                                                  else
                                                  {
                                                empresa.StartTransaction();
                                                      Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                                                      Actividad.CardCode ="P44444401";
                                                      Actividad.ActivityType = -1;
                                                      Actividad.Activity = BoActivities.cn_Other;
                                                      Actividad.Details = "Creación de la Orden de Trabajo";
                                                      Actividad.Notes = "CREACION OT";
                                                      Actividad.EndDuedate = DateTime.Now.Date;
                                                      Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                                                      Actividad.Closed = BoYesNoEnum.tYES;

                                                      if (Actividad.Add() != 0)
                                                      {
                                                          String error2=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                             %><%=error2%> 2<%

                                                    empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                    return;
                                                }
                                                else
                                                {
                                                    clgcode = empresa.GetNewObjectKey();

                                                    OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                                                    OT.Activities.ActivityCode = int.Parse(clgcode);
                                                    OT.ServiceBPType = ServiceTypeEnum.srvcPurchasing;
                                                    OT.CustomerCode = "P44444401";
                                                    OT.Subject = problema;
                                                    OT.Description = descripcion;
                                                    OT.Origin = int.Parse(origen.Trim());
                                                    OT.ProblemType =int.Parse(tipo_problema);
                                                    OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                                                    OT.Activities.UserFields.Fields.Item("U_usuario").Value =nombre_usuario;
                                                    OT.UserFields.Fields.Item("U_recurso").Value=maquina;
                                                     OT.UserFields.Fields.Item("U_sub_categoria").Value=id_categoria;
                                                    OT.Status = 3;
                                                     if (OT.Add() != 0)
                                                    {
                                                        String error1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                                                        %><%=error1%> 1<%   

                                                      empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                      return;
                                                  }
                                                  nro_ot = empresa.GetNewObjectKey();

                                                  OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                                                  OT.GetByKey(int.Parse(nro_ot));
                                                   Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);

                                                  Actividad.CardCode ="P44444401";
                                                  Actividad.ActivityType = -1;
                                                  Actividad.Activity = BoActivities.cn_Other;
                                                  Actividad.Details = "PENDIENTE";
                                                  Actividad.Notes = "PENDIENTE ASIGNACION OPERARIOS ";
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
                                                  OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                                                    OT.Activities.UserFields.Fields.Item("U_usuario").Value =nombre_usuario ;

                                                            if (OT.Update()!=0)

                                                            {
                                                                String error1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                                                            };  }





                                                        };
                                                    };
                                                    empresa.EndTransaction(BoWfTransOpt.wf_Commit);
%>   <script>
              
            
                swal({
                    
                title: "REGISTRADO CON EXITO" , 
               
                confirmButtonText: "CERRAR" 



                });


                      $("#txt_ruc").val("");
                      $("#txt_nombre").val("");
                      $("#description").val("");
                      $("#txt_problema").val("");
                      $("#div_maquina").hide();
                      $('#cbox_origen option').prop('selected', function () {
                      return this.defaultSelected;
                           });
                     $('#cbox_origen option').prop('selected', function() {
                      return this.defaultSelected;
                           });


                     
                    $.preloader.stop();
                



        </script>       <%    


                                      /*   SmtpClient correo = new SmtpClient();
                            correo.Port = 587;
                            correo.Host = "smtp.gmail.com";
                            correo.EnableSsl = true;
                            correo.DeliveryMethod = SmtpDeliveryMethod.Network;
                            correo.UseDefaultCredentials = false;
                            correo.Credentials = new System.Net.NetworkCredential("reportes.vmiis@gmail.com", "gm$12345622");
                            String mail_1 = "";
                            String mail_2 = "";

                            //MailMessage mm = new MailMessage("reportes.vmiis@gmail.com", "felix.gaona@yemita.com.py", "Error Interface CAST", msj);
                            MailMessage mm = new MailMessage();
                            mm.From = new MailAddress("reportes.vmiis@gmail.com");
                                                        
                                String[] mail_arr = mail.Split('-');
                                mail_1=mail_arr[0];
                                mail_2=mail_arr[1];
                                mm.To.Add(mail_1);
                                mm.To.Add(mail_2);
                                                           
                            mm.Subject = "PEDIDO DE TRABAJO";
                            mm.Body = "SOLICITUD NRO: "+clgcode+" \n\n SOLICITADO POR: "+nombre_usuario+" \n\n DESCRIPCION: "+descripcion+"\n\n DETALLE: "+problema;
                           correo.Send(mm);*/
                                                };
            
       

                
            }
                            
            catch(Exception ex)
            {
               if(empresa.InTransaction)
                {
                empresa.EndTransaction(BoWfTransOpt.wf_RollBack);

                };
                %><script>
                 swal({
                title: "<%=ex%>" , 
                confirmButtonText: "CERRAR" 
                }); </script>
                <% 
            }
            finally
            {
                if (empresa.Connected)
                {
 
                            empresa.Disconnect(); 
                };
                
            };}



                           

    %>
   