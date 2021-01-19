<%@ Page Language="C#" AutoEventWireup="true" %>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
        SqlCommand rs;
        SqlDataReader dr;
        if (Session["nombre_usuario"] == null)
        {
            Response.Redirect("login.aspx");
        }
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
  <table  id="tabla_informe" class="table"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
                    <th>NRO.</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>RESOLUCIÓN</th>
                 <th>ACCIÓN</th>
                    <th>ACCIÓN</th>
             </tr> 
            <%

                try
                {


                    //status -2 = a pendiente 
                    rs = new SqlCommand(" select  os.descrption, os.status, os.subject, os.callid, t4.nombre, sc.U_Id_Usuario,os.resolution 	  " +
                        "from oscl os  inner join scl5 sc on os.callID=sc.SrvcCallId    " +
                        "inner join osco c on c.originID=os.origin   " +
                        "inner join oclg oc on oc.ClgCode=sc.ClgID   " +
                        "inner join grupomaehara.dbo.ot_usuario t4 on  sc.U_Id_Usuario=t4.cod_usuario  " +
                        "where     os.status='5'  " +
                        "and sc.Line='0'  " +
                        "and sc.U_Id_Usuario='"+id_usuario+"'", cnn);

                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                        String id= dr["callid"].ToString();
                        String descripcion= dr["subject"].ToString();
                        String descrption= dr["descrption"].ToString();
                       String resolution= dr["resolution"].ToString();


               %>
                        <tr id="<%=id%>"class="alternar"   >  
                        <td><%=id%></td>
                        <td><%=descripcion%></td>
                        <td><%=descrption%></td>
                         <td><%=resolution%></td> 
                            
                            <td>
 
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-success "  onclick="$('#id_orden').val(<%=id%>);"  value="APROBAR VERIFICACION">
                                </td>

                            <td>
 
                              <input type="button" data-toggle="modal" data-target="#modal1" data-dismiss="modal"   class="btn btn-warning "  onclick="$('#id_ot').val(<%=id%>);"  value="RECHAZAR">
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
               

        function cerrar_registro(id,motivo) {
             
            $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });

                 $.get('control_rechazar_resolucion.aspx', { id: id,motivo:motivo},
                function(res){
                    
                     $("#contenido_div").html(res);
                });

            
              
           
        }
           
              
        function aprobar(id) {
             
            $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });

                 $.get('control_verificacion.aspx', { id: id},
                function(res){
                    
                     $("#contenido_div").html(res);
                });

            
              
           
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
                 
                </div><div class="form-inline text-center">
                
                     <input type="text" id="id_orden" name="id_orden" style="display:none">

                                      


                   
                 
                <br><br><br><br><br>
                 
                <input style="width:500px; height:80px" class="btn btn-primary  " data-dismiss="modal"type="button" value="REGISTRAR"  onclick="aprobar($('#id_orden').val());"  > 
                    <br>
                  <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                </div>
                </div></div>   </div>              </form> 











<form id="frm_agregar5"    method="POST">
                 
                <div class="modal fade" id="modal1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                 RECHAZAR RESOLUCION
                </div><div class="form-inline text-center">
                
                     <input type="text" id="id_ot" name="id_ot" style="display:none">
                   <input type="text" id="txt_motivo_rechazo" name="txt_motivo_rechazo"  class="form-control" placeholder="INGRESAR MOTIVO ">

                                      


                   
                 
                <br><br><br><br><br>
                 
                <input style="width:500px; height:80px" class="btn btn-primary  " data-dismiss="modal"type="button" value="REGISTRAR"  onclick="cerrar_registro($('#id_ot').val(),$('#txt_motivo_rechazo').val());"  > 
                    <br>
                  <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                </div>
                </div></div>   </div>              </form> 