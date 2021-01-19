<%@ Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %> 
<% @Import Namespace="System.Net.Mail" %> 

    <%    Contacts Actividad;
           if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }
        String conn = Global.sap_conn;
        String conn_gm = Global.gm_conn;
        SqlConnection cnn_gm = new SqlConnection(conn_gm);
        SqlConnection cnn_sap = new SqlConnection(conn);
        String id_actividad = "";
        string clgcode="";
        string resolucion_anterior = "";
        Company empresa = new Company();
        ServiceCalls OT;
        //Contacts Actividad;
        String id_ot = Request.Params["id"];
        String txt_resolucion = Request.Params["txt_resolucion"];
        String txt_maquina = Request.Params["maquina"];
        String txt_detalle = Request.Params["detalle"];
        String txt_descripcion = Request.Params["descripcion"];
        String nombre_usuario = Session["nombre_usuario_gm"].ToString();

        String id_usuario =Session["id_usuario"].ToString();
        SqlCommand rs,rs2,rs3,rs1;
        String id_usuario_mail = "";
        SqlDataReader dr,dr2,dr3,dr1;
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

        cnn_gm.Open();

        String mail = "";

     

        rs3 = new SqlCommand(" select os.callid,sc.U_Id_Usuario  " +
            " from oscl os inner join scl5 sc on os.callID=sc.SrvcCallId    " +
            "where    sc.Line=0   and os.status =4 and os.callID="+id_ot+"", cnn_sap);


        dr3 = rs3.ExecuteReader();
        while (dr3.Read())
        {   id_usuario_mail = dr3["U_Id_Usuario"].ToString();


        }
        dr3.Close();





           rs1 = new SqlCommand("select correo from ot_usuario where cod_usuario="+id_usuario_mail+"", cnn_gm);
       
        dr1 = rs1.ExecuteReader();
        while (dr1.Read())
        {   mail = dr1["correo"].ToString();


        }
        dr1.Close();





        rs = new SqlCommand(" select * from oclg where parentid="+id_ot+"and closed='N'", cnn_sap);

        dr = rs.ExecuteReader();
        while (dr.Read())
        {   id_actividad = dr["clgcode"].ToString();

        }
        dr.Close();





        rs2 = new SqlCommand("  select resolution  from  oscl where callid='"+id_ot+"'", cnn_sap);

        dr2 = rs2.ExecuteReader();
        while (dr2.Read())
        {   resolucion_anterior = dr2["resolution"].ToString();

        }
        dr2.Close();


        try
        {
            if (empresa.Connected == false)
            {

                if (empresa.Connect() != 0)
                {
                    String ERROR1=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());

                        %><%=ERROR1%>   <script>
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
                   Actividad.EndDuedate= DateTime.Parse(DateTime.Now.ToString());
                   Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                           
                   if (Actividad.Update() != 0)
                   {
                    String error2=(empresa.GetLastErrorDescription() + "; COdigo de error :" + empresa.GetLastErrorCode().ToString());
                          %><%=error2%> 2<%
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
                Actividad.Details = "CARGADA";
                Actividad.Notes = "RESOLUCION CARGADA";
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
                Actividad.Notes = "PENDIENTE VERIFICACION";
                Actividad.EndDuedate = DateTime.Now.Date;
                //Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                 
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
                                                                OT.Resolution = resolucion_anterior+"\n"+txt_resolucion;
                                                                OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                                                                OT.Activities.UserFields.Fields.Item("U_usuario").Value =nombre_usuario;

                                                                OT.Status = 5;

                                                                if (OT.Update()!=0)

                                                                {
                                                                    String error1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                                                                };
                                                            }
                                                        };

                                                        empresa.EndTransaction(BoWfTransOpt.wf_Commit);

                                                        %>   <script>
                                        swal({
                                        title: "REGISTRADO CON EXITO" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                               traer_informe_resolucion();
                                      </script>       
                                    <%    
                                                                                                     
                                    SmtpClient correo = new SmtpClient();
                                    correo.Port = 587;
                                    correo.Host = "smtp.gmail.com";
                                    correo.EnableSsl = true;
                                    correo.DeliveryMethod = SmtpDeliveryMethod.Network;
                                    correo.UseDefaultCredentials = false;
                                    correo.Credentials = new System.Net.NetworkCredential("reportes.vmiis@gmail.com", "gm$12345622");
                                    MailMessage mm = new MailMessage();
                                     mm.From = new MailAddress("reportes.vmiis@gmail.com");                                                        
                                     mm.To.Add(mail);                                                        
                                     mm.Subject = "PEDIDO DE TRABAJO";                                                        
                                     mm.Body = "SOLICITUD NRO: " + id_ot + " \n\n MAQUINA: "+txt_maquina+" DESCRIPCION: "+txt_descripcion+" \n\n DETALLE: "+txt_detalle+" \n\n RESOLUCION REALIZADA  POR: " + nombre_usuario;                                                        
                                    correo.Send(mm);
                                                   
                                                    };

                                                }

                                                catch(Exception ex)
                                                {
                                             if(empresa.InTransaction)
                {
                empresa.EndTransaction(BoWfTransOpt.wf_RollBack);

                };
                                                    String ERROR1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                                                    %>     
                                      <script>
                                        swal({
                                        title: " <%=ex%>" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
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
   