 <%@ Page Language="C#" AutoEventWireup="true"   %>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    SqlCommand rs,rs3,rs4;
     SqlDataReader dr,dr3,dr4;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    String customer=  Request.Params["customer"];
    cnn.Open();
    String area_formato = "";
    String estado_formateado = "";
    
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
                     <th>CREADO POR.</th>
                 <th>MAQUINA</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>AREA</th>
                 <th>TIPO DE PROBLEMA</th>
                 <th>FECHA DE CREACION</th>   
                 <th>NOTA</th>
                 <th>RECHAZAR</th>
                 <th>APROBAR</th>
            </tr> 
                  </thead>
            <%
                try
                {

                    String detalle = "";
                    rs = new SqlCommand("exec select_informe_ot_perf3 @area='"+area+"',@customer='"+customer+"' ", cnn);
                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                         detalle=Regex.Replace(dr["descrption"].ToString(), @"\r\n?|\n", "-");

             %>
                        <tr class="alternar"   >  
                        <td><%=dr["callid"].ToString()%></td>
                        <td><%=dr["u_usuario"].ToString()%></td>
                        <td><%=dr["maquina"].ToString()%></td>
                        <td><%=dr["subject"].ToString()%></td>
                        <td><%=detalle%></td>
                        <td><%=dr["name"].ToString()%></td>
                        <td><%=dr["tipo_problema"].ToString()%></td>
                        <td><%=dr["createdate"].ToString()%></td>
                        <td><textarea readonly  style="width:500px; height:100px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>
                        <td>
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-warning "  onclick="$('#id_orden').val(<%=dr["callid"].ToString()%>);"  value="CERRAR ORDEN">
                              </td>
                              <td>
                    <input type="button"   class="btn btn-success "  onclick="form_aprobar_mant('<%=dr["proveedor"].ToString()%>','<%=dr["callid"].ToString()%>','<%=detalle%>','<%=dr["subject"].ToString()%>');"  value="APROBAR">
 
 
                              </td> 
                        </tr>   
      <%
                   }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {   } 
         
%>      
      
          </table> 
     
    <input type="text" id="id_orden" name="id_orden" style="display:none"  >
    <input type="text" id="descripcion" name="descripcion"  style="display:none"  >
    <input type="text" id="detalle" name="detalle" style="display:none">
    
    
    <div id="contenido_div"> </div>
 </form>

    <form id="frm_agregar4"    method="POST">
                 
        <div class="modal fade" id="4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                    <input type="text" id="txt_comentario" name="txt_comentario" placeholder="INGRESAR MOTIVO" class="form-control">
                    <h5 class="modal-title" id="exampleModalLabel"></h5>
                    </div>
                        <div class="form-inline text-center">
                        <br><br><br><br><br>
                            <input style="width:500px; height:80px" class="btn btn-primary" data-dismiss="modal" type="button" value="CERRAR ORDEN"  onclick="anular_registro_mant($('#id_orden').val(),$('#txt_comentario').val());"  > 
                            <br>
                            <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                        </div>
                </div>
            </div>   
        </div>              
    </form>
 




  