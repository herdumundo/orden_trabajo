<%@ Page Language="C#" AutoEventWireup="true" %>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
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
  <table  id="tabla_informe" class="table"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
                    <th>NRO.</th>
                  <th>MAQUINA</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>USUARIO</th>
                 <th>AREA</th>
                 <th>RECHAZAR</th>
                 <th>APROBAR</th>
            </tr> 
            <%

                try
                {

                    String condicion = area;

                    String area_sql = "";

                    if (condicion.Trim().Equals("CCH"))
                    {

                        area_sql = "gm.area in ('ccha','cchb','ovo')";
                    }

                    else if (condicion.Trim().Equals("PPR"))
                    {

                        area_sql = "gm.area in ('PPR-A','PPR-B','AVI-T')";
                    }

                    else if (condicion.Trim().Equals("AFTLSA"))
                    {

                        area_sql = "gm.area in ('AVI-T','FER','TALLER','LOG','SUSTENTABILIDAD','ADM')";
                    }

                    else if (condicion.Trim().Equals("FBFC"))
                    {

                        area_sql = "gm.area in ('FBAL','FCART')";
                    }

                     else if (condicion.Trim().Equals("FCART"))
                    {

                        area_sql = "gm.area in ('LOG','FCART','FERT')";
                    }


                    else {
                        area_sql = "gm.area='"+condicion+"'";
                    }
                    //status -2 = a pendiente 
                    rs = new SqlCommand(" select os.descrption,os.status,os.subject,os.callid,sc.U_Id_Usuario ,gm.nombre,gm.area ,maq.resname as maquina " +
                        " from oscl os inner join scl5 sc on os.callID=sc.SrvcCallId  " +
                        "inner join GrupoMaehara.dbo.ot_usuario gm on sc.U_Id_Usuario=gm.cod_usuario " +
                        "inner join oclg oc on oc.ClgCode=sc.ClgID  " +
                        "inner join orsc maq on maq.rescode=os.U_recurso   " +
                        "where   "+area_sql+" and oc.Closed='N' and os.status='1' ", cnn);


                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                        String id= dr["callid"].ToString();
                        String descripcion= dr["subject"].ToString();
                        String estado= dr["descrption"].ToString();
                        String nombre= dr["nombre"].ToString();
                        String area_usuario= dr["area"].ToString();
                         String MAQUINA= dr["maquina"].ToString();
               %>
                        <tr id="<%=id%>"class="alternar"   >  
                        <td ><%=id%></td>
                        <td><%=MAQUINA%></td>
                        <td><%=descripcion%></td>
                        <td><%=estado%></td>
                        <td><%=nombre%></td>
                        <td><%=area_usuario%></td>
                            
                            <td>
 
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-warning "  onclick="$('#id_orden').val(<%=id%>);"  value="CERRAR ORDEN">
                                </td>


                            <td>
            
                 <input type="button"   onclick="aprobar_registro(<%=id%>,'<%=descripcion%>','<%=estado%>');" class="btn btn-success example2 " value="APROBAR">
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
           function aprobar_registro(id,descripcion,detalle){
              
            $.get('control_aprobar.aspx', { id: id,descripcion:descripcion,detalle:detalle},
                function (res)
                {
                    
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

    <div id="contenido_div"> </div>
 </form>

<form id="frm_agregar4"    method="POST">
                 
                <div class="modal fade" id="4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                     <input type="text" id="txt_comentario" name="txt_comentario" placeholder="INGRESAR MOTIVO" class="form-control">
                
                </div><div class="form-inline text-center">
                
                     <input type="text" id="id_orden" name="id_orden" style="display:none">
                     
                <br><br><br><br><br>
                 
                <input style="width:500px; height:80px" class="btn btn-primary  " data-dismiss="modal"type="button" value="CERRAR ORDEN"  onclick="anular_registro($('#id_orden').val(),$('#txt_comentario').val());"  > 
                    <br>
                  <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                </div>
                </div></div>   </div>              </form> 