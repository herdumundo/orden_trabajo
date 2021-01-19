<%@ Page Language="C#" AutoEventWireup="true"   %>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    SqlCommand rs,rs2;
    SqlDataReader dr,dr2;
             if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String conn = Global.conn;

    String conn_gm = Global.gm_conn;
    SqlConnection cnn_gm = new SqlConnection(conn_gm);
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    String area_formato = "";
    String estado_formateado = "";
  
    cnn_gm.Open();

  

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
  <table  id="tabla_informe" class="table"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
                    <th>NRO.</th>
                 <th>MAQUINA</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>ACCION</th>
                 
            </tr> 
            <%

                try
                {
                    //status -2 = a pendiente 
                    rs = new SqlCommand(" select distinct(ot.callid),ot.subject,maq.resname," +
                        "a.U_Id_Usuario,convert(varchar,ot.descrption) as descrption " +
                      
                        "from oscl ot inner join scl5 a on ot.callid=a.SrvcCallId  " +
                        "inner join oclg ac on a.clgid=ac.clgcode  " +
                          "inner join orsc maq on maq.rescode=ot.U_recurso " +
                        "where ot.status=4 and ac.U_Id_asignado="+id_usuario+" group by ot.callid,ot.subject,a.U_Id_Usuario,convert(varchar,ot.descrption),maq.resname", cnn);


                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                        String id= dr["callid"].ToString();
                        String descripcion= dr["subject"].ToString();
                        String detalle= dr["descrption"].ToString();
                         String maquina= dr["resname"].ToString();

               %>
                        <tr id="<%=id%>"class="alternar"   >  
                        <td><%=id%></td>
                             <td><%=maquina%></td>
                        <td><%=descripcion%></td>
                        <td><%=detalle%></td>
                          
                            
                            <td>
 
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-success "  onclick="$('#id_orden').val(<%=id%>),$('#maquina_info').val('<%=maquina%>'),$('#descripcion_info').val('<%=descripcion%>'),$('#detalle_info').val('<%=detalle%>');"  value="AGREGAR RESOLUCION">
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
    <script>
        function enviar_resolucion(id, txt_resolucion,maquina,descripcion,detalle) {

            var txt_resolucion = $('#txt_resolucion').val();
            var maquina = $('#maquina_info').val();
            var descripcion = $('#descripcion_info').val();
            var detalle = $('#detalle_info').val();

           
            if (txt_resolucion == "") {

                   swal({
                    
                title: "ERROR INGRESE RESOLUCION", 
                  
                confirmButtonText: "CERRAR" 
                });

            }
            else {
                $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });
                $.get('control_resolucion.aspx', { id: id,txt_resolucion:txt_resolucion,maquina:maquina,descripcion:descripcion,detalle:detalle},
                    function (res)
                    {
                    
                     $("#contenido_div").html(res);
                });

            }
          
        }     

        
          $(function(){

          

            // Advanced example
            $('.example2').click(function(){

                $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });
 

            });

           

        });



            </script>

    <div id="contenido_div"> </div>
 </form>

<form id="frm_agregar4"    method="POST">
                 
                <div class="modal fade" id="4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                     <textarea   style="text-transform: uppercase;"  name = "txt_resolucion" id="txt_resolucion" class="form-control" placeholder="RESOLUCION"></textarea>
                <h5 class="modal-title" id="exampleModalLabel"></h5>
                </div> 
                
                     <input type="text" id="id_orden" name="id_orden" style="display:none" >
                    
                     
        
                 
                  
                <input  class="form-control btn btn-primary  " type="button" value="REGISTRAR"  onclick="enviar_resolucion($('#id_orden').val(),$('#txt_resolucion').val(),$('#maquina_info').val(),$('#descripcion_info').val(),$('#detalle_info').val());" data-dismiss="modal"  > 
                    <br><br>
                  <button class="form-control btn btn-danger " type="button" data-dismiss="modal">VOLVER</button>
              
                 
                </div></div> <div id="id_s"></div>  </div>           
     <input type="text" id="maquina_info" name="maquina_info" style="display:none" >
                     <input type="text" id="descripcion_info" name="descripcion_info" style="display:none" >
                     <input type="text" id="detalle_info" name="detalle_info" style="display:none" >

</form>


