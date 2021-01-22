<%@ Page Language="C#" AutoEventWireup="true" %>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
            if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
    SqlCommand rs;
    SqlDataReader dr;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();;
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
  
    %>


 
<script>
              
            function modal_animacion(i){
                swal({
                    
                title: "DETALLE DE ORDEN NRO."+i, 
                html: "<div id='div_grilla'></div>",  
                confirmButtonText: "CERRAR" 
                        });
                                        } 
        </script> 


<style>
     .alternar:hover{ background-color:#ffcc66;}
    </style>

<form id="grilla_ot" method="post">
  <table  id="tabla_informe" class="table table-striped table-bordered"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              <thead>
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
                    <th>NRO.</th>
                  <th>MAQUINA</th>
                  <th>PROVEEDOR</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>CREADO POR</th>
                 <th>AREA</th>
                 <th>FECHA DE CREACION</th>
                 <th>RECHAZAR</th>
                 <th>APROBAR</th>
            </tr> 
                  </thead>
            <%

                try
                {
                    String condicion = area;
                    String area_sql = "";
                    if (condicion.Trim().Equals("CCH"))
                    {
                        area_sql = "gm.area in ('ccha','cchb','ovo','cchh')";
                    }
                    else if (condicion.Trim().Equals("PPR"))
                    {
                        area_sql = "gm.area in ('PPR-A','PPR-B','AVI-T','PPR','SANI')";
                    }
                    else if (condicion.Trim().Equals("AFTLSA"))
                    {
                        area_sql = "gm.area in ('AVI-T','FER','TALLER','LOG','SUSTENTABILIDAD','ADM')";
                    }
                    else if (condicion.Trim().Equals("FBFC"))
                    {
                        area_sql = "gm.area in ('FBAL','FCART')";
                    } 
                    else if (condicion.Trim().Equals("'LOG'"))
                    {
                        area_sql = "gm.area in ('LOG'')";
                    }
                     else if (condicion.Trim().Equals("FCART"))
                    {
                      //    area_sql = "gm.area in ('FCART','FERT')";
                      area_sql = "gm.area in ('LOG','FCART','FERT')";
                    }
                    else {
                        area_sql = "gm.area='"+condicion+"'";
                    }
                    //status -2 = a pendiente 
                    rs = new SqlCommand(" select os.descrption,os.status,os.subject,os.callid,sc.U_Id_Usuario ,gm.nombre,gm.area ,maq.resname as maquina,os.createdate,CASE OC.CardCode  WHEN 'P44444401' THEN 'MANT' ELSE 'LOG' END AS proveedor " +
                        " from oscl os with(nolock) inner join scl5 sc with(nolock) on os.callID=sc.SrvcCallId  " +
                        "inner join GrupoMaehara.dbo.ot_usuario gm on sc.U_Id_Usuario=gm.cod_usuario " +
                        "inner join oclg oc with(nolock) on oc.ClgCode=sc.ClgID  " +
                        "LEFT OUTER join orsc maq with(nolock) on maq.rescode=os.U_recurso   " +
                        "where   "+area_sql+" and oc.Closed='N' and os.status='1' ", cnn);
                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                         String est=Regex.Replace(dr["descrption"].ToString(), @"\r\n?|\n", "-"); %>
                        <tr id="<%= dr["callid"].ToString()%>"class="alternar"   >  
                            <td><%= dr["callid"].ToString()%></td>
                            <td><%= dr["maquina"].ToString()%></td>
                            <td><%= dr["proveedor"].ToString()%></td>
                            <td><%= dr["subject"].ToString()%></td>
                            <td><%= dr["descrption"].ToString()%></td>
                            <td><%= dr["nombre"].ToString()%></td>
                            <td><%= dr["area"].ToString()%></td>
                            <td><%= dr["createdate"].ToString()%></td>
                            <td>
                            <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-warning "  onclick="$('#id_orden').val(<%=dr["callid"].ToString()%>);"  value="CERRAR ORDEN">
                            </td>
                            <td>
                            <input type="button"   onclick="aprobar_registro(<%=dr["callid"].ToString()%>,'<%=dr["subject"].ToString()%>','<%=est%>','<%=dr["proveedor"].ToString()%>');" class="btn btn-success example2 " value="APROBAR">
                            </td> 
                        </tr>   
      <%            }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {   }  %>      

    </table>
   
    
    <div id="contenido_div"> </div>
    </form>

            <form id="frm_agregar4"    method="POST">
                <div class="modal fade" id="4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                <input type="text" id="txt_comentario" name="txt_comentario" placeholder="INGRESAR MOTIVO" class="form-control">
                
                </div>
                    <div class="form-inline text-center">
                    <input type="text" id="id_orden" name="id_orden" style="display:none">
                    <br><br><br><br><br>
                    <input style="width:500px; height:80px" class="btn btn-primary  " data-dismiss="modal"type="button" value="CERRAR ORDEN"  onclick="anular_registro_ot_admin($('#id_orden').val(),$('#txt_comentario').val());"  > 
                    <br>
                    <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                    </div>
                </div>
                </div>   
              </div>              
            </form> 
<%cnn.Close();%>