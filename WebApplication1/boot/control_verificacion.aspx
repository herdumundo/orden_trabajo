<%@ Page Language="C#" AutoEventWireup="true" %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %> 

    <%    
         if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }
        Contacts Actividad;
        String conn = Global.sap_conn;

        SqlConnection cnn_sap = new SqlConnection(conn);
        String id_actividad = "";
        string clgcode="";
        Company empresa = new Company();
        ServiceCalls OT;
        //Contacts Actividad;
        String id_ot = Request.Params["id"];
        String comentario=Request.Params["txt_comentario"];
        String nombre_usuario = Session["nombre_usuario_gm"].ToString();
        String id_usuario =Session["id_usuario"].ToString();
        SqlCommand rs;
        SqlDataReader dr;
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
        empresa.Password =Session["pass"].ToString();

        cnn_sap.Open();

        rs = new SqlCommand(" select * from oclg where parentid="+id_ot+"and closed='N'", cnn_sap);

        dr = rs.ExecuteReader();
        while (dr.Read())
        {   id_actividad = dr["clgcode"].ToString();

        }
        dr.Close();

        try
        {
            if (empresa.Connected == false)
            {

                if (empresa.Connect() != 0)
                {
                    String ERROR1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                        %><%=ERROR1%>
                                                  <script>
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
                           
                   if (Actividad.Update() != 0)
                   {
                    String error2=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
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
 
                Actividad.Notes =  "VERIFICACION APROBADA";
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

                                                        OT.Status = -1;
                                                       
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
                                              traer_informe_verificacion();
                                      </script>       
                                    <%  

                                            };
                                        }

                                        catch(Exception ex)
                                        {

                                              if(empresa.InTransaction)
                                                    {
                                                    empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                                                    };
                                            String ERROR1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                                                      %>   <script>
                                              
                                        swal({
                                        title: "<%=ex%>" , 
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
   