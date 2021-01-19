 <%@ Page Language="C#" AutoEventWireup="true"%>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;\
    if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }
    SqlCommand rs;
    SqlDataReader dr;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario = Session["id_usuario"].ToString();
    String estado_formateado = "";
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open(); %>






INGRESAR FECHA DESDE:      
                
                <input class="datepicker"   type="text" id="calendario_estado" name="calendario_estado">
 
                <script>
      $('.datepicker').pickadate({
  // Escape any “rule” characters with an exclamation mark (!).
  format: 'yyyy-mm-dd',
  formatSubmit: 'yyyy-mm-dd',
  hiddenPrefix: 'prefix__',
            hiddenSuffix: '__suffix',
            cancel: 'Cancelar',
            clear: 'Limpiar',
            done: 'Ok',
            today: 'Hoy',
          close: 'Cerrar',
            max: true,
           monthsFull: [ 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre' ],
    monthsShort: [ 'ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic' ],
    weekdaysFull: [ 'Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado' ],
    weekdaysShort: [ 'dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb' ],
    
   
});

                    function llamar_grilla(fecha,fecha_fin,estado) {

                         $.get('grilla_estado_perf1.aspx', { fecha: fecha,fecha_fin:fecha_fin,estado:estado }, function (res) {
            $("#contenido_grilla").html(res);
        });

                    }
    </script>
<div><br /> 
    
INGRESAR FECHA HASTA:      
                
                <input class="datepicker"   type="text" id="calendario_hasta" name="calendario_hasta">
</div>
<div>



    <br />

    SELECCIONAR ESTADO DEL DOCUMENTO


     <select class="form-control" name="cbox_estado" id="cbox_estado"" >
                  
                 <%  
                     String id = "";
                     String descripcion = "";


                     rs = new SqlCommand("SELECT * FROM OSCS", cnn);

                     dr = rs.ExecuteReader();
                     while (dr.Read())
                     {
                         id=dr["statusid"].ToString();
                         descripcion=dr["descriptio"].ToString();

 %> 
     <OPTION VALUE="<%=id%>"><%=descripcion%></OPTION>
             
            <% } dr.Close();%>
                
            </select> 




<br />
<input type="button" value="BUSCAR" class="form-control" onclick="llamar_grilla($('#calendario_estado').val(),$('#calendario_hasta').val(),$('#cbox_estado').val());"/>

</div>

<div id="contenido_grilla"> 


</div>


