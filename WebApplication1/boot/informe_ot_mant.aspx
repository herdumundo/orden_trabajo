 <%@ Page Language="C#" AutoEventWireup="true"   %>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    SqlCommand rs,rs3,rs4;
           if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
    SqlDataReader dr,dr3,dr4;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
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
  <table  id="tabla_informe" class="table"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
                    <th>NRO.</th>
                 <th>MAQUINA</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>AREA</th>
                 <th>RECHAZAR</th>
                 <th>APROBAR</th>
            </tr> 
            <%
                try
                {
                    //status -2 = a pendiente 
                    rs = new SqlCommand("select t1.u_usuario,t2.name,maq.resname as maquina,* " +
                        "from oscl t0 " +
                        "inner join scl5 t1 on t0.callid=t1.SrvcCallId " +
                        "inner join osco t2 on t0.origin=t2.originid " +
                         "inner join orsc maq on maq.rescode=t0.U_recurso " +
                        "where t1.Line=0 and t0.status=2", cnn);
                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                        String id= dr["callid"].ToString();
                        String descripcion= dr["subject"].ToString();
                        String estado= dr["descrption"].ToString();
                        String area_usuario= dr["name"].ToString();
                         String MAQUINA= dr["maquina"].ToString();
                        String area_usuario_res = "";

                        if (area_usuario.Equals("CCHA")||area_usuario.Equals("CCHB")||area_usuario.Equals("OVO"))
                        {
                            area_usuario_res = "CCH";
                        }
                        else if (area_usuario.Equals("FBAL"))
                        {
                            area_usuario_res = "FBFC";
                        }
                        else if (area_usuario.Equals("PPR-B"))
                        {
                            area_usuario_res = "PPR-B";
                        }
                        else if (area_usuario.Equals("PPR-A"))
                        {
                            area_usuario_res = "PPR-A";
                        }

                        else if (area_usuario.Equals("AVI-T")||area_usuario.Equals("TALLER")||area_usuario.Equals("ADM")||area_usuario.Equals("FERT")||area_usuario.Equals("LOG")||area_usuario.Equals("SUSTENTABILIDAD"))
                        //
                        {
                            area_usuario_res = "AFTLSA";
                        }
                        else
                        {
                            area_usuario_res = area_usuario;
                        }
             %>
                        <tr id="<%=id%>"class="alternar"   >  
                        <td><%=id%></td>
                               <td><%=MAQUINA%></td>
                        <td><%=descripcion%></td>
                        <td><%=estado%></td>
                        <td><%=area_usuario%></td>
                        <td>
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-warning "  onclick="$('#id_orden').val(<%=id%>);"  value="CERRAR ORDEN">
                              </td>
                              <td>
                           <!-- <input type="button"   onclick="aprobar_registro(<%//=id%>)" class="btn btn-success example2 " value="APROBAR">!-->
 <input type="button" data-toggle="modal" data-target="#5" data-dismiss="modal"   class="btn btn-success "  onclick="$('#id_orden').val(<%=id%>);$('#detalle').val('<%=estado%>');$('#descripcion').val('<%=descripcion%>'); validar_formato_area('<%=area_usuario_res%>');"  value="APROBAR">
 
 
                              </td> 
                        </tr>   
      <%
                   }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {   } 
         
%>      

  <script>
    function validar_formato_area(area_get) {
               $('#cbox_encargado_mant option').filter(function () {
            return this.id === area_get
        }).prop('selected', true);
       
    }
      </script>

    
   
    
              
          </table> 
    <script>
           function aprobar_registro(id){
                  var cbox_proveedor = $('#cbox_proveedor option:selected').toArray().map(item => item.value).join();
               var combo_proveedor = cbox_proveedor.trim();
               var cbox_encargado = $("#cbox_encargado_mant :selected").val();
               var descripcion = $("#descripcion").val();
                var detalle = $("#detalle").val();


            $.get('control_aprobar_mant.aspx', { id: id,combo_proveedor:combo_proveedor,cbox_encargado:cbox_encargado,descripcion:descripcion,detalle:detalle},
                function(res){
                    
                     $("#contenido_div").html(res);
                });
        }     

      function anular_registro(id, txt_comentario) {

            var descripcion = $("#txt_comentario").val();

            if (descripcion.length == 0) {

                 swal({
                    
                title: "ERROR INGRESE MOTIVO", 
                  
                confirmButtonText: "CERRAR" 
                });
               
                

            }


            else { $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });

                 $.get('control_cancelar.aspx', { id: id, txt_comentario:txt_comentario},
                function(res){
                    
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
    <input type="text" id="id_orden" name="id_orden" style="display:none">
    <input type="text" id="descripcion" name="descripcion" style="display:none"  >
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
                </div><div class="form-inline text-center">
                
                     

                                        
                   
                 
                <br><br><br><br><br>
                  
                <input style="width:500px; height:80px" class="btn btn-primary" data-dismiss="modal" type="button" value="CERRAR ORDEN"  onclick="anular_registro($('#id_orden').val(),$('#txt_comentario').val());"  > 
                    <br>
                  <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                </div>
                </div></div>   </div>              </form>

            <form id="frm_agregar5"    method="POST">
                 
                <div class="modal fade" id="5" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                <div id="combo" class="form-group">                 
                          
       <a>TERCERIZADOS</a>
        <input type="checkbox"   data-toggle="toggle" data-on="SI"    data-off="NO" id="chkToggle2" data-onstyle="success"    data-offstyle="warning">
            <script>
                $(function () { $('#chkToggle2').bootstrapToggle() });
                  $(function () {

    $('#chkToggle2').change(function () {
        if ($(this).prop("checked") == true) {
            $('#cbox_proveedor').show();
           // $('#cbox_operario').hide();
            deseleccionar_multiselect();
            
        }
        else {
           // $('#cbox_operario').show();
            $('#cbox_proveedor').hide();
            deseleccionar_proveedor();
        }
    });
});
 
 
          function validar() {
              var cbox = $('#cbox_operario').val();
               var cbox_prov  = $('#cbox_proveedor').val();

              if (cbox.length === 0&&cbox_prov==="-") {
                  
                swal({
                    
                title: "ERROR, SELECCIONAR OPERARIO!!!" , 
               
                confirmButtonText: "CERRAR" 
                 });
                                        }
                 else {
                 $(function(){
 
                $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });
                            });
                  enviar();
              }
                }
                 
             function enviar() {
 
                 var operario = $('#cbox_operario option:selected').toArray().map(item => item.value).join();
                 var nro_ot = $('#id_orden').val();
                 var cbox_proveedor = $('#cbox_proveedor option:selected').toArray().map(item => item.value).join();
                 var combo_proveedor = cbox_proveedor.trim();
                              insertar_registro(operario,nro_ot,combo_proveedor);
                
             }
         

               function insertar_registro(operario,nro_ot,cbox_proveedor){
              
                $.get('control_asignacion.aspx',{operario:operario,nro_ot:nro_ot,cbox_proveedor:cbox_proveedor},
                function(res){
                    
                     $("#id_s").html(res);
                });
            }  

         </script>    
                    
                </div>
                </div><div class="form-inline text-center">
                
                     <input type="text" id="id_orden_terc" name="id_orden_terc" style="display:none" >
                    <script>
                        function deseleccionar_multiselect() {
                        $("#cbox_operario option:selected").prop("selected", false);

                        }
                         function deseleccionar_proveedor() {
                        $("#cbox_proveedor option:selected").prop("selected", false);
                        }
                    </script>
                               <select style="display:none" name="cbox_proveedor"   id="cbox_proveedor" class="form-control"  multiple="multiple">
                        <%
                 
       rs3 = new SqlCommand("select * from ocrd where U_rubro_prov is not null", cnn);
       dr3 = rs3.ExecuteReader();
       while (dr3.Read())
       {
           String id_proveedor= dr3["cardcode"].ToString();
           String nombre_proveedor= dr3["cardname"].ToString();
     %> 
 <option value="<%=nombre_proveedor%>"><%=nombre_proveedor%></option>
   <%}
       dr3.Close();
       %> 
    </select>
                    <br>
                       
              <div  >        
                  <br><br>
<a>ENCARGADO DE MANTENIMIENTO</a> <br>
 <select name="cbox_encargado_mant"   id="cbox_encargado_mant" class="form-control">
                        <%
       rs4 = new SqlCommand(" select distinct  b.empid as id_empleado,(c.firstName +' '+c.lastName )as nombre, z.area  from ohtm a inner join  htm1 b on a.teamID=b.teamID inner join ohem c on b.empID=c.empID inner join grupomaehara.dbo.ot_usuario z on z.cod_usuario=b.empID  where c.Active='Y' and  b.role='L' order by 2", cnn);
       dr4 = rs4.ExecuteReader();
       while (dr4.Read())
       {
           String id_proveedor= dr4["id_empleado"].ToString();
           String nombre_proveedor= dr4["nombre"].ToString();
          String area_global= dr4["area"].ToString();
     %> 
 <option id="<%=area_global%>" value="<%=id_proveedor%>"><%=nombre_proveedor%></option>
   <%}
       dr4.Close();
       %> 
    </select>
</div>  
                  <div>
                <input style="width:500px; height:80px" class="btn btn-primary  example2 " id="id_registro" type="button" value="APROBAR"  onclick="aprobar_registro($('#id_orden').val()); " data-dismiss="modal"  > 
                    <br>
                  <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
               </div>
                      
                  </div>
                </div></div> <div id="id_s"></div>  </div>             
                  </form>





 