<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>

<form method="post" id="form_ot">
<% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
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
        
               
         <input name="txt_problema" style="text-transform: uppercase;" autocomplete="off" id="txt_problema"  type="text" class="form-control" "placeholder="PROBLEMA">
          <br>
         DETALLE DEL PROBLEMA
        <textarea style="text-transform: uppercase;"  name = "description" id="description" class="form-control"></textarea>
         <br>
      

 <select class="form-control" name="cbox_origen" id="cbox_origen" onchange="meter_valores_en_txt(); filtrar();" >
                <OPTION value="" disabled selected>Origen</OPTION>
               
                 <%  

                     String condicion = area;

                     String area_sql = "";

                     if (condicion.Trim().Equals("CCH"))
                     {

                         area_sql = "name in ('ccha','cchb','ovo')";
                     }

                   else   if (condicion.Trim().Equals("PPR"))
                     {

                         area_sql = "name in ('PPR-A','PPR-B','AVI-T')";
                     }

                      else   if (condicion.Trim().Equals("MANT"))
                     {

                         area_sql = "name in ('MANT','TALLER','ccha','cchb','ovo','PPR-A','PPR-B','AVI-T','LOG')";
                     }
                      else   if (condicion.Trim().Equals("FCART"))
                     {

                         area_sql = "name in ('FCART')";
                     }

                      else   if (id_usuario.Trim().Equals("33"))
                     {

                         area_sql = "name in ('MANT','TALLER','ccha','cchb','ovo','PPR-A','PPR-B','AVI-T','LOG')";
                     }
                       
                     else {
                         area_sql = "name='"+condicion+"'";
                     }
                         if (id_usuario.Trim().Equals("30"))
                     {

                         area_sql = "name in ('MANT','TALLER','ccha','cchb','ovo','PPR-A','PPR-B','AVI-T','LOG')";
                     }
                     rs = new SqlCommand(" select *from osco where "+area_sql+"", cnn);

                     dr = rs.ExecuteReader();
                     while (dr.Read())
                     {
                         id=dr["originID"].ToString();
                         descripcion=dr["descriptio"].ToString();

 %> 
     <OPTION VALUE="<%=id%>"><%=descripcion%></OPTION>
             
            <% } dr.Close();%>
                
            </select> 
    
    <br>
    <div id="div_maquina" style="display:none">


    </div>

        <br> 
         <link href="css/jquery-ui.css" rel="stylesheet" />
    <script src="js/jquery-ui.js"></script>
    <div id="sub_categoria">
 
    </div>
             <br>
  <select class="form-control" name="cbox_tipo_problem" id="cbox_tipo_problem">
                <OPTION value="" selected disabled>TIPO DE PROBLEMA</OPTION>
               
                 <%  
	      rs1 = new SqlCommand(" select * from oscp", cnn);
          dr1 = rs1.ExecuteReader();
          while (dr1.Read())
          {
        id_proble=dr1["prblmTypID"].ToString();
        descripcion_proble=dr1["Descriptio"].ToString();

 %> 
     <OPTION VALUE="<%=id_proble%>"><%=descripcion_proble%></OPTION>
             
            <% } dr1.Close();%>
                
            </select>  
     <br> <br>

    <input type="button" value="Registrar" id="btn_registrar" name="btn_registrar" class="form-control btn btn-info "   onclick="validar_envio();" />
            
   
        <input type="text" value="-" id="txt_bolean_maquina" name="txt_bolean_maquina" style="display:none"  />

    <br>  
        
 
    <input type="text" id="txt_test" style="display:none" />
    <script>

            function filtrar(){
	        var id = document.getElementById("txt_test").value   
            var actualiza_parte = new XMLHttpRequest();
	        actualiza_parte.onreadystatechange = function(){
	        if(this.readyState === 4 && this.status === 200){
	        var response = this.responseText;
            document.getElementById("div_maquina").innerHTML=response;  } };
            actualiza_parte.open("GET", "combo_maquina.aspx?id="+id+"", true);
            actualiza_parte.send();
            $("#div_maquina").show();
         }
        
        function filtrar_sub_categoria() {
                var id = document.getElementById("cbox_maquina").value 
             var actualiza_parte = new XMLHttpRequest();
	        actualiza_parte.onreadystatechange = function(){
	        if(this.readyState === 4 && this.status === 200){
	        var response = this.responseText;
            document.getElementById("sub_categoria").innerHTML=response;  } };
            actualiza_parte.open("GET", "combo_articulo.aspx?id="+id+"", true);
            actualiza_parte.send();
            $("#sub_categoria").show();
         }

        function meter_valores_en_txt() {
        var text;
        text = $('#cbox_origen').val();
        $('#txt_test').val(text);}
        </script>
        </form>

<div id="contenido_ot"></div>
 <script>

        $(function(){
           // Advanced example
            $('.example2').click(function(){

                $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });
             });
     });

     function validar_envio() {
         var maquina = $('#txt_bolean_maquina').val();
         var problema = $('#txt_problema').val();
         var descripcion= $('#description').val();

         if (maquina == '-'||problema==""||descripcion=="") {

             alert('ERROR,CARGAR DATOS');
         }

         else {
             enviar_datos_ot(<%=perfil%>);
             $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });

         }

     }
    </script>