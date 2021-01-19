<%@ Page Language="C#" AutoEventWireup="true"   %>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;

           if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
    SqlCommand rs,rs2,rs3;
    SqlDataReader dr,dr2,dr3;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    
    //String area_formato = "";
    String area_informe = "";

    if (area.Trim().Equals("CCH"))
    {
        area_informe = "in ('ccha','cchb','ovo')";

    }
    else if  (area.Equals("FBFC"))
    {
        area_informe = "in ('FBAL','FCART')";

    }
    else
    {

        area_informe="='"+area+"'";
    }

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
   )
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
                 <th>ASIGNAR OPERARIOS</th>
                 
            </tr> 
            <%

                try
                {
                    //status -2 = a pendiente 
                    rs = new SqlCommand("select t1.u_usuario ,t0.descrption,t0.subject,t0.callid,  t3.Name ,maq.resname as maquina " +
                        "from oscl t0 inner join scl5 t1 on t0.callid=t1.SrvcCallId " +
                        "inner join oclg t2 on t1.ClgID=t2.ClgCode " +
                        "inner join osco t3 on t0.origin=t3.originid " +
                        "inner join orsc maq on maq.rescode=t0.U_recurso " +
                        "where  t0.status=3   " +
                        "and t2.U_Id_Asignado='"+id_usuario.Trim()+"'", cnn);


                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                        String id= dr["callid"].ToString();
                        String descripcion= dr["subject"].ToString();
                        String detalle= dr["descrption"].ToString();
                        String area_usuario= dr["name"].ToString();
                        String MAQUINA= dr["maquina"].ToString();
               %>
                        <tr id="<%=id%>"class="alternar"   >  
                        <td><%=id%></td>
                            <td><%=MAQUINA%></td>
                        <td ><%=descripcion%></td>
                        <td ><%=detalle%></td>
                         <td><%=area_usuario%></td>

                            
                            <td>
 
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-success "  onclick="$('#id_orden').val(<%=id%>);"  value="ASIGNAR">
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
           function aprobar_registro(id){
              
            $.get('control_aprobar_mant.aspx', { id: id},
                function(res){
                    
                     $("#contenido_div").html(res);
                });
        }     

        function anular_registro(id,txt_comentario){
              
            $.get('control_cancelar.aspx', { id: id, txt_comentario:txt_comentario},
                function(res){
                    
                     $("#contenido_div").html(res);
                });
        }
          
         
            </script>


    
    <div id="contenido_div"> </div>
 </form>

<form id="frm_agregar4"    method="POST">
                 
                <div class="modal fade" id="4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                <div class="modal-content">
                    ASIGNAR OPERARIO
                <div class="modal-header">
                     
                
                <div id="combo" class="form-group">                 
                <select  name="cbox_operario"   id="cbox_operario"  multiple="multiple"   >


                    <%
                  /*if (area.Trim().Equals("CCH"))
                    {

           area_formato = "a.name='CCH/OVO'";
                    }

                else  if (area.Trim().Equals("FBFC"))
                    {

           area_formato = "a.name in ('FABBAL','FCART')";
                    }

                else   
                    {

           area_formato = "a.name ='"+area+"'";
                    }*/
       rs2 = new SqlCommand("select distinct  b.empid as id_empleado,(c.firstName +' '+c.lastName )as nombre  from ohtm a inner join   " +
                                 "htm1 b on a.teamID=b.teamID  " +
                                     "inner join ohem c on b.empID=c.empID where  b.role='m'    and c.Active='Y' and b.empid not in('"+id_usuario+"') order by 2", cnn);
       dr2 = rs2.ExecuteReader();
       while (dr2.Read())
       {
           String id_op= dr2["id_empleado"].ToString();
           String nombre= dr2["nombre"].ToString();
     %> 
 <option value="<%=id_op%>"><%=nombre%></option>
   <%} dr2.Close(); %> </select>


      


<br>

                
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
 
 
          function validar_asignacion() {
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
                  enviar_asignacion();
              }
                }

               

   
 
             function enviar_asignacion() {
 
                 var operario = $('#cbox_operario option:selected').toArray().map(item => item.value).join();
                 var nro_ot = $('#id_orden').val();
                 var cbox_proveedor = $('#cbox_proveedor option:selected').toArray().map(item => item.value).join();
                 var combo_proveedor = cbox_proveedor.trim();
                 //var fecha_inicio = $('#calendario').val();
                 //var fecha_fin = $('#calendario_hasta').val();

                // insertar_registro_asignacion(operario,nro_ot,combo_proveedor,fecha_inicio,fecha_fin);
                                 insertar_registro_asignacion(operario,nro_ot,combo_proveedor);

             }
         

               //function insertar_registro_asignacion(operario,nro_ot,cbox_proveedor,fecha_inicio,fecha_fin){
                             function insertar_registro_asignacion(operario,nro_ot,cbox_proveedor){
               // $.get('control_asignacion.aspx',{operario:operario,nro_ot:nro_ot,cbox_proveedor:cbox_proveedor,fecha_inicio:fecha_inicio,fecha_fin:fecha_fin},

                $.get('control_asignacion.aspx',{operario:operario,nro_ot:nro_ot,cbox_proveedor:cbox_proveedor},
                function(res){
                    
                     $("#id_s").html(res);
                });
            }  

         </script>    
                 <div>

    <br />   
<!--INGRESAR FECHA PROGRAMADA DE INICIO:      
                 <br />  
  
             
     <input id="calendario" type="date"data-format="yyyy-mm-dd"      />
    
<br />  <br />  

                    INGRESAR FECHA PROGRAMADA DE FINALIZACION:      
                 <br />  
  
             
     <input id="calendario_hasta"  type="date" data-format="yyyy-mm-dd"      />-->
    </div> 

</div>   
                

  

 
                </div><div class="form-inline text-center">
                
                     <input type="text" id="id_orden" name="id_orden" style="display:none" >

 
               
                 
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
                 
                  <div>
                <input style="width:500px; height:80px" class="btn btn-primary  example2 " id="id_registro" type="button" value="REGISTRAR"  onclick="validar_asignacion();" data-dismiss="modal"  > 
                    <br>
                  <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
               </div>
                      
                  </div>
                </div></div> 
    
    
    
    
    
    
    <div id="id_s"></div>                
                  </form>