
function login(perfil) {

    if (perfil == "1") {
        $(Document).ready(function () {
            traer_menu();
           no_volver_atras();
             });
    }

    else if (perfil == "2") {

        $(Document).ready(function () {
            traer_menu_admin();
             no_volver_atras();
        });
    }

    else if (perfil == "3") {

        $(Document).ready(function () {
            traer_menu_mant();
            no_volver_atras();
        });
    }


    else if (perfil == "4") {

        $(Document).ready(function () {
            traer_menu_encargado_mantenimiento();
            no_volver_atras();
        });
    }

}

function no_volver_atras() {

    window.location.hash = "no-back-button";
    window.location.hash = "Again-No-back-button" //traer_informe_resolucion
    window.onhashchange = function () { window.location.hash = "no-back-button"; }

}


function traer_contenedor_menu_admin() {
    $("#contenido_principal").html("");
    $("#contenido_principal").show();
    $.get('contenedor_menu_admin.aspx', function (res) {
        $("#contenido_principal").html(res);

    });
}



function traer_contenedor_menu_em() {
    $("#contenido_principal").html("");
    $("#contenido_principal").show();
    $.get('contenedor_menu_em.aspx', function (res) {
        $("#contenido_principal").html(res);

    });
}



function traer_contenedor_menu_admin_mant() {
    $("#contenido_principal").html("");
    $("#contenido_principal").show();
    $.get('contenedor_menu_admin_mant.aspx', function (res) {
        $("#contenido_principal").html(res);

    });
}

function traer_contenedor_menu() {
    $("#contenido_principal").html("");
    $("#contenido_principal").show();
    $.get('contenedor_menu.aspx', function (res) {
        $("#contenido_principal").html(res);

    });
}

function traer_menu() {
    $("#div_index").html("");
    $("#div_index").show();
     $.get('menu.aspx', function (res) {
         $("#div_index").html(res);
          traer_contenedor_menu();

    });
}

function traer_menu_admin() {
    $("#div_index").html("");
    $("#div_index").show();
     $.get('menu_admin.aspx', function (res) {
         $("#div_index").html(res);
         traer_contenedor_menu_admin();
    });
}




function traer_menu_encargado_mantenimiento() {
    $("#div_index").html("");
    $("#div_index").show();
    $.get('menu_em.aspx', function (res) {
        $("#div_index").html(res);
        traer_contenedor_menu_em();
    });
}



function traer_menu_mant() {
    $("#div_index").html("");
    $("#div_index").show();
    $.get('menu_admin_mant.aspx', function (res) {
        $("#div_index").html(res);
        traer_contenedor_menu_admin_mant();
    });
}


function traer_ot() {
    $("#contenido").html("");
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();

    $.get('orden_trabajo.aspx', function (res) {
        $("#contenido").html(res);
      
    });
    ;
}
function traer_informe_ot() {
    $("#contenido").html("");
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();

    $.get('informe_ot.aspx', function (res) {
        $("#contenido").html(res);
        $('#tabla_informe').bootstrapTable();

    });
}


function traer_informe_ot_mant() {
    $("#contenido").html("");
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();

    $.get('informe_ot_mant.aspx', function (res) {
        $("#contenido").html(res);
        $('#tabla_informe').bootstrapTable();
    });
}



function traer_informe_resolucion() {
    $("#contenido").html("");
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();

    $.get('informe_resolucion.aspx', function (res) {
        $("#contenido").html(res);
        $('#tabla_informe').bootstrapTable();
    });
}



function traer_informe_verificacion() {
    $("#contenido").html("");
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();

    $.get('informe_veri_admin.aspx', function (res) {
        $("#contenido").html(res);
        $('#tabla_informe').bootstrapTable();
    });
}



function traer_informe_asignacion() {
    $("#contenido").html("");
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();

    $.get('informe_ot_em.aspx', function (res) {
        $("#contenido").html(res);
        $('#tabla_informe').bootstrapTable();
      
    });
    


}





function traer_informe_ot_admin() {
    $("#contenido").html("");
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();

    $.get('informe_ot_admin.aspx', function (res) {
        $("#contenido").html(res);
        $('#tabla_informe').bootstrapTable();
    });
}
function traer_detalle(id) {

    $.get('grilla_detalle_ot.aspx', { id: id }, function (res) {
        $("#div_grilla").html(res);
    });
} function traer_contendor_cambiar_pass_asp() {
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();
    $("#contenido").html("");
    $.get('contenedor_password.aspx', function (res) {
        
        $("#contenido").html(res);
    });
}

function traer_contendor_informe_perfil1() {
    $("#contenido_principal").html("");
    $("#contenido_principal").hide();
    $("#contenido").html("");
    $.get('informe_estado_perf1.aspx', function (res) {

        $("#contenido").html(res);
        $('#tabla_informe').bootstrapTable();
       
    });
}