<%@ Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>
 
    <%   if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }

        String elemento = "";
        String elemento_proveedor = "";
        String conn = Global.sap_conn;
        String operario= Request.Params["operario"];
        String nro_ot= Request.Params["nro_ot"];
        // String fecha_inicio= Request.Params["fecha_inicio"];
        // String fecha_fin= Request.Params["fecha_fin"];
        //  String proveedor= Request.Params["cbox_proveedor"];
        // String condicion=""; ;
        String id_proveedor = "";
        String nombre_proveedor = "";
        String nombre_usuario = Session["nombre_usuario_gm"].ToString();
        String id_usuario =Session["id_usuario"].ToString();
        SqlConnection cnn_sap = new SqlConnection(conn);
        SqlCommand rs,rs2;
        SqlDataReader dr,dr2;
        String clgcode = "";
        String user_name = "";
        Company empresa = new Company();
        UserTable usuario;
        UserTable usuario2;
        Contacts Actividad;
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
        rs = new SqlCommand(" select * from oclg where parentid="+nro_ot+"and closed='N'", cnn_sap);
        dr = rs.ExecuteReader();
        while (dr.Read())
        {   id_actividad = dr["clgcode"].ToString();

        }
        dr.Close();
        String[] elementos_operario = operario.Split(',');
        // String[] elementos_proveedor = proveedor.Split(',');

        /* if (proveedor.Length>0)
         {
             condicion = "SI";
         }
         else
         {
             condicion = "NO";
         }*/

        /*String detalle_anterior = "";
        rs2 = new SqlCommand("  select subject  from  oscl where callid='"+nro_ot+"'", cnn_sap);

        dr2 = rs2.ExecuteReader();
        while (dr2.Read())
        {   detalle_anterior = dr2["subject"].ToString();

        }
        dr2.Close();
        */

        try
        {
            if (empresa.Connected == false)
            {
                if (empresa.Connect() != 0)
                {
                    String ERROR1 = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                        %><%=ERROR1%>  error1 
                                      <script>
                                        swal({
                                        title: "<%=ERROR1%>" , 
                                        confirmButtonText: "CERRAR" 
                                              });
                                        $.preloader.stop();
                                       </script>       
                                    <%  
                                                  }
                                                  else   {
                                                      empresa.StartTransaction();
                                                      if (operario.Length > 0) {
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
                                                          for(int i=0; i<elementos_operario.Length; i++)
                                                          {
                                                              elemento=elementos_operario[i];
                                                              rs = new SqlCommand("select (firstName+' '+lastName) as nombre from ohem where empID='"+elemento+"'", cnn_sap);
                                                              dr = rs.ExecuteReader();
                                                              while (dr.Read())
                                                              {   user_name = dr["nombre"].ToString();
                                                              }
                                                              dr.Close();
                                                              //Setting Data to Child Table Fields
                                                              oChildren = oGeneralData.Child("OT_OP");
                                                              oChild = oChildren.Add();
                                                              oChild.SetProperty("U_Id_Operario",elemento);
                                                              oChild.SetProperty("U_Nombre_Operario", user_name);
                                                              //Attempt to Add the Record
                                                          }
                                                          oGeneralService.Add(oGeneralData);
                                                      }
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
   
                OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                Actividad =  (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                OT.GetByKey(int.Parse(nro_ot));
                Actividad.CardCode ="P44444401";
                Actividad.ActivityType = -1;
                Actividad.Activity = BoActivities.cn_Other;
                Actividad.Details = "ASIGNADO";
                Actividad.Notes = "ASIGNACION REALIZADA";
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
                OT.GetByKey(int.Parse(nro_ot));
                Actividad.CardCode ="P44444401";
                Actividad.ActivityType = -1;
                Actividad.Activity = BoActivities.cn_Other;
                Actividad.Details = "PENDIENTE";
                Actividad.Notes = "PENDIENTE DE RESOLUCION";
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
                                                                /*  OT.UserFields.Fields.Item("U_ot_tercer").Value =condicion;
                                                                  OT.UserFields.Fields.Item("U_prov_terc").Value =proveedor;*/
                                                                OT.Status = 4;
                                                                if (OT.Update()!=0)
                                                                {
                                                                    String error1=(empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                                                                };
                                                            }
                                                        }
                                                empresa.EndTransaction(BoWfTransOpt.wf_Commit);
                                                         %>
                                             <script>
                                                    swal({
                                                        title: "ASIGNACION REGISTRADA!!!" , 
                                                        confirmButtonText: "CERRAR" 
                                                         });
                                                    $.preloader.stop();
                                                    traer_informe_asignacion();
                                                </script> 
                                    <%
                                                    };
                                                  /*  if (empresa.InTransaction) {
                                                        empresa.EndTransaction(SAPbobsCOM.BoWfTransOpt.wf_Commit);
                                                    }*/
                                                } catch(Exception ex){
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
                                                </script>     <%    
                             }%>