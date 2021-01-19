<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>

<form method="post" id="form_ot">
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %>
<% 
          if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    String id = "";
    String descripcion = "";
    String id_proble = "";
    String descripcion_proble = "";
    String perfil = Session["perfil"].ToString();
    String area=Session["area"].ToString();
 String id_usuario=Session["id_usuario"].ToString();
    SqlCommand rs,rs1;
    SqlDataReader dr,dr1;
%>
  <input type="checkbox"  data-toggle="toggle" data-on="LOGISTICA" data-off="MANTENIMIENTO" id="chkToggle2" data-onstyle="success" data-offstyle="warning">
    
    <input style="display:none" type="text" value="P44444401" id="condicion_ot" name="condicion_ot"/>
    <br><br>
     <div class="form-groupss " >
         
         <label class="form-control-placeholder"><b>Descripcion</b></label>
         
         <input name="txt_problema" style="text-transform: uppercase;" autocomplete="off" id="txt_problema"  type="text" class="form-control" "placeholder="PROBLEMA">
 
      </div>        
              

          <br>

    <div class="form-groupss " >
         
         <label class="form-control-placeholder"><b>DETALLE DEL PROBLEMA</b></label>
         
        <textarea style="text-transform: uppercase;"  name = "description" id="description" class="form-control"></textarea>
 
      </div>  
         
         <br>
      

      <div class="form-groupss " >
         
         <label class="form-control-placeholder"><b>Origen</b></label>
         <select class="form-control" name="cbox_origen" id="cbox_origen" onchange="meter_valores_en_txt(); filtrar();" >
                <OPTION value="" disabled selected>Origen</OPTION>
               
                 <%  

                     String condicion = area;

                     String area_sql = "";


                     if (id_usuario.Trim().Equals("30"))
                     {

                         area_sql = "select *from osco where  name in ('MANT','TALLER','ccha','cchb','ovo','PPR-A','PPR-B','AVI-T','LOG','PPR','FCART','FERT')";

                     }

                     else
                     {

                       
 
                            area_sql = " select *from osco where name in (select area collate database_default from grupomaehara.dbo.ot_perfiles_areas where area_perfil='" + condicion.Trim() + "')";
 


                     }

                     rs = new SqlCommand(area_sql, cnn);
                     dr = rs.ExecuteReader();
                     while (dr.Read())
                     {
                         id=dr["originID"].ToString();
                         descripcion=dr["descriptio"].ToString();

 %> 
     <OPTION VALUE="<%=id%>"><%=descripcion%></OPTION>
             
            <% } dr.Close();%>
                
            </select> 
  
      </div>  

 
    
    <br>
    <div id="div_maquina" style="display:none">


    </div>

        <br> 
         <link href="css/jquery-ui.css" rel="stylesheet" />
    <script src="js/jquery-ui.js"></script>
    <div id="sub_categoria">
 
    </div>
             <br>



      <div class="form-groupss " >
         
         <label class="form-control-placeholder"><b>TIPO DE PROBLEMA</b></label>
         <select class="form-control" name="cbox_tipo_problem" id="cbox_tipo_problem">
                <OPTION value="" selected disabled>TIPO DE PROBLEMA</OPTION>
               
                 <%  
	      rs1 = new SqlCommand(" select * from oscp with(nolock) ", cnn);
          dr1 = rs1.ExecuteReader();
          while (dr1.Read())
          {
        id_proble=dr1["prblmTypID"].ToString();
        descripcion_proble=dr1["Descriptio"].ToString();

 %> 
     <OPTION VALUE="<%=id_proble%>"><%=descripcion_proble%></OPTION>
             
            <% } dr1.Close();%>
                
            </select> 
  
      </div>  

   
     <br>  

    <input type="button" value="Registrar" id="btn_registrar" name="btn_registrar" class="form-control btn btn-info "   onclick="validar_envio(<%=perfil%>);" />
            
   
        <input type="text" value="-" id="txt_bolean_maquina" name="txt_bolean_maquina" style="display:none"  />

    <br>  
        
 
    <input type="text" id="txt_test" style="display:none" />
   
        </form>

<div id="contenido_ot"></div>
 