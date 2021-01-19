<%@ Page Language="C#" AutoEventWireup="true" %>
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
        String conn_gm = Global.gm_conn;
        SqlConnection cnn_sap = new SqlConnection(conn);
        SqlConnection cnn_gm = new SqlConnection(conn_gm);
        String id_actividad = "";
        string clgcode="";
        Company empresa = new Company();
        ServiceCalls OT;
        String cbox_encargado= Request.Params["cbox_encargado"];
        String proveedor= Request.Params["combo_proveedor"];
        String condicion=""; ;
        //Contacts Actividad;
        String id_ot = Request.Params["id"];
        String descripcion = Request.Params["descripcion"];
        String detalle = Request.Params["detalle"];
        String nombre_usuario =Session["nombre_usuario_gm"].ToString();
        String comentario=Request.Params["txt_comentario"];
        String id_usuario =Session["id_usuario"].ToString();
        SqlCommand rs,rs2;
        SqlDataReader dr,dr2;
        String mail = "";
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


        rs2 = new SqlCommand(" select * from ot_usuario where cod_usuario="+cbox_encargado+"", cnn_gm);

        dr2 = rs2.ExecuteReader();
        while (dr2.Read())
        {   mail = dr2["correo"].ToString();

        }
        dr2.Close();
        rs = new SqlCommand(" select * from oclg where parentid="+id_ot+"and closed='N'", cnn_sap);
        if (proveedor.Length>0)
        {
            condicion = "SI";
        }
        else
        {
            condicion = "NO";
        }
        dr = rs.ExecuteReader();
        while (dr.Read())
        {   id_actividad = dr["clgcode"].ToString();

        }
        dr.Close();
        //////////////////////////////////////////////////////////////////////////////////////////////////
        ///

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
                Actividad.Details = "APROBADA";
                Actividad.Notes = "OT APROBADA JEFE MANTENIMIENTO";
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
                                                //Actividad.SalesEmployee =int.Parse(cbox_encargado);
                                                Actividad.UserFields.Fields.Item("U_Id_Asignado").Value =int.Parse(cbox_encargado);
                                                 Actividad.Notes = "PENDIENTE ASIGNACION OPERARIOS";
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
                                                        OT.UserFields.Fields.Item("U_ot_tercer").Value =condicion;
                                                        OT.UserFields.Fields.Item("U_prov_terc").Value =proveedor;
                                                         OT.Status = 3;
                                                       
                                                        if (OT.Update()!=0)

                                                        {
                                                            String error1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                                                        };
                                                                            }
                                                              }; empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                                                        %>   <script>
                                        swal({
                                        title: "REGISTRADO CON EXITO" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                              traer_informe_ot_mant();
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
                                                mm.To.Add(mail);
                                                mm.Subject = "PEDIDO DE TRABAJO";
                                                mm.Body = "SOLICITUD NRO: " + id_ot + " \n\n APROBADO Y ASIGNADO  POR: " + nombre_usuario + "\n\n DESCRIPCION: "+descripcion+"\n\n DETALLE: "+detalle;
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

                                                                                             }
                                                           finally                                  
                                                         {                                    
                                                              if (empresa.Connected)                                   
                                                                 {                                
                                                                  empresa.Disconnect();                                   
                                                                    };
                                                                     };                                  
                                                                                                

                                                                                           









                        %>
   