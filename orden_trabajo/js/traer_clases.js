var ruta_contenedores = "./contenedores/";
var ruta_controles = "./controles/";
var ruta_grillas = "./grillas/";
var ruta_consultas = "./consultas/";
    function login(perfil) {
         $(Document).ready(function () {
                    ir_menu(perfil);
                    });
           }

    function no_volver_atras() {

        window.location.hash = "no-back-button";
        window.location.hash = "Again-No-back-button" //traer_informe_resolucion
        window.onhashchange = function () { window.location.hash = "no-back-button"; }
     }
 

 
 

function ir_menu(perfil) {


    var url;
    if (perfil == "1") {
        url = ruta_contenedores + 'contenedor_menu.aspx';
    }

    else if (perfil == "2") {
        url = ruta_contenedores + 'contenedor_menu_admin.aspx';

    }

    else if (perfil == "3") {

        url = ruta_contenedores + 'contenedor_menu_admin_mant.aspx';

    }


    else if (perfil == "4") {
        url = ruta_contenedores + 'contenedor_menu_em.aspx';

    }
    else if (perfil == "5") {
        url = ruta_contenedores + 'contenedor_menu_admin_mant.aspx';
    }

    $.ajax({
        type: "POST",
        url: url,
        beforeSend: function () {
            $("#contenido_principal").html("");
            $("#contenido").html("");
             $("#loading").show();
        },
        success: function (data) {
            $("#loading").hide();
            $("#contenido_principal").show();

            $("#contenido_principal").html(data);
            if (perfil == "5") {
                $("#div_logistica").show();
                $("#div_resolucion").show();
             }
                }
    });
    no_volver_atras();
}
 
 

 


function traer_ot() {
    $.ajax({
        type: "POST",
        url: ruta_contenedores +'orden_trabajo.aspx',
        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (data) {
            $("#loading").hide();
            $("#contenido").html(data);
            $('#chkToggle2').bootstrapToggle();
            cargar_toggles_ot();
            $("#cbox_origen").prop('required', true);
            $("#cbox_tipo_problem").prop('required', true);
            $("#cbox_maquina").prop('required', true);
            cargar_estilo_calendario();
        }
    });
}
function traer_informe_ot() {

    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_ot.aspx',
        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (data) {
            $("#loading").hide();
            $("#contenido").html(data);
            $('#tabla_informe').DataTable(); 
        }
    });

 
}
function cargar_estilo_calendario() {
    $('.datepicker').pickadate({
        // Escape any “rule” characters with an exclamation mark (!).
        format: 'dd/mm/yyyy',
        formatSubmit: 'dd/mm/yyyy',
        hiddenPrefix: 'prefix__',
        hiddenSuffix: '__suffix',
        cancel: 'Cancelar',
        clear: 'Limpiar',
        done: 'Ok',
        today: 'Hoy',
        close: 'Cerrar',
        max: true,
        monthsFull: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
        monthsShort: ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'],
        weekdaysFull: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
        weekdaysShort: ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb']
    });
}

function traer_informe_ot_mant(customer) {

    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_ot_mant.aspx',
        data: ({ customer: customer}),
        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (data) {
            $("#loading").hide();

            $("#contenido").html(data);
            $('#chkToggle2').bootstrapToggle();
            $(function () {
            $('#chkToggle2').change(function () {
                if ($(this).prop("checked") == true) {
                $('#cbox_proveedor').show();
                        deseleccionar_multiselect();
                    }
                    else {
                        $('#cbox_proveedor').hide();
                        deseleccionar_proveedor();
                    }
                                                });
            });
            $('#tabla_informe').DataTable({
                "scrollX": true
            }); 
        }

    });

 
}




function traer_informe_resolucion() {
    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_resolucion.aspx',
        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (data) {
            $("#loading").hide();
            $("#contenido").html(data);
            $('#tabla_informe').DataTable({
                "scrollX": true,
                "pageLength": 100
            });
        }
    });
 
}

function traer_informe_verificacion() {

    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_veri_admin.aspx',
        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido").html(res);
            $('#tabla_informe').DataTable({
                "scrollX": true,
                "pageLength": 100
            }); 
        }
    }); 
}
 


function traer_informe_asignacion() {
        $.ajax({
        type: "POST",
            url: ruta_contenedores +'informe_ot_em.aspx',

        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido").html(res);
            $('#tabla_informe').DataTable({
                "pageLength": 100,
                "scrollX": true
            });
         }

    }); 
 
    }





function traer_informe_ot_admin() {



    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_ot_admin.aspx',
 
        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
          },
        success: function (res) {
            $("#loading").hide();

            $("#contenido").html(res);
           // $('#tabla_informe').bootstrapTable();
            $('#tabla_informe').DataTable({
                "scrollX": true
            });
        }

    }); 
 
}
function traer_detalle(id) {


    $.ajax({
        type: "POST",
        url: ruta_grillas+'grilla_detalle_ot.aspx',
        data: ({id: id }),
        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();

            $("#div_grilla").html(res);
        }

    }); 

} 


function traer_contendor_cambiar_pass_asp() {


    $.ajax({
        type: "POST",
        url: ruta_contenedores +'contenedor_password.aspx',

        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();

            $("#contenido").html(res);
         }

    });

 
    }

function traer_contendor_informe_perfil1() {


    $.ajax({
        type: "POST",
        url: ruta_contenedores+'informe_estado_perf1.aspx',

        beforeSend: function () {
            $("#contenido").html("");
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido").html(res);
            $('#tabla_informe').bootstrapTable();
            cargar_calendario();
        }

    });

 
}
function llamar_grilla(fecha, fecha_fin ) {


    $.ajax({
        type: "POST",
        url: ruta_grillas +'grilla_estado_perf1.aspx',
        data: ({ fecha: fecha, fecha_fin: fecha_fin }),
        beforeSend: function () {
      
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido_grilla").html(res);
             filtrar_grilla();
        }

    });
     
}
function llamar_grilla2(fecha, fecha_fin, estado) {



    $.ajax({
        type: "POST",
        url: ruta_grillas +'grilla_estado_perf2.aspx',
        data: ({ fecha: fecha, fecha_fin: fecha_fin, estado: estado }),
        beforeSend: function () {

            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido_grilla").html(res);
            filtrar_grilla();
        }

    });

 
}
function cargar_calendario() {
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
    monthsFull: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
    monthsShort: ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'],
    weekdaysFull: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
    weekdaysShort: ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb'],


});
}


function traer_contendor_informe_perfil2() {
 
    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_estado_perf2.aspx',
         beforeSend: function () {
             $("#contenido_principal").html("");
             $("#contenido_principal").hide();
             $("#contenido").html("");
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido").html(res);
          
            cargar_calendario();
            //$('#tabla_informe').bootstrapTable();
          
        }

    });
         }

 
function ir_historial_pendientes_perf2() {

    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_global_perf_2.aspx',
        beforeSend: function () {
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#contenido").html("");
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido").html(res);
            $('#tabla_global_inf_2').DataTable({
                  "scrollX": true,
                "pageLength": 100

            }); 
        }

    });
}

 
function ir_historial_pendientes_perf3() {

    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_global_perf_3.aspx',
        beforeSend: function () {
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#contenido").html("");
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido").html(res);
            $('#tabla_global_inf_3').DataTable({
                "scrollX": true,
                "pageLength": 100

            });
        }

    });
}



function cargar_estilo_grilla(id) {
    $('#'+id).DataTable({
     //   "scrollX": true,
          "pageLength": 100

    }); 
}
function traer_contendor_informe_perfil3() {

    $.ajax({
        type: "POST",
        url: ruta_contenedores +'informe_estado_perf3.aspx',
        beforeSend: function () {
            $("#contenido_principal").html("");
            $("#contenido_principal").hide();
            $("#contenido").html("");
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido").html(res);
            cargar_calendario();
            $('#tabla_informe').bootstrapTable();

        }

    });
 
}
function llamar_grilla_3(fecha, fecha_fin) {
 $.ajax({
        type: "POST",
        url: ruta_grillas +'grilla_estado_perf3.aspx',
        data: ({ fecha: fecha, fecha_fin: fecha_fin }),
        beforeSend: function () {
 
            $("#loading").show();
        },
        success: function (res) {
            $("#loading").hide();
            $("#contenido_grilla").html(res);
            filtrar_grilla_acordeon();
        }
    });
     }
function filtrar_grilla() {

    
    $(".buscar").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $(".tabla_informe tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });

}

function filtrar_grilla_acordeon() {



    $("#buscar-1").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe-1 tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });

    }); $("#buscar-2").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe-2 tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });

        $("#buscar-3").on("keyup", function () {
            var value = $(this).val().toLowerCase();
            $("#tabla_informe-3 tr").filter(function () {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
    });

    $("#buscar1").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe1 tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
    $("#buscar2").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe2 tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });


    $("#buscar3").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });


    $("#buscar3").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });



    $("#buscar4").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe4  tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });



    $("#buscar5").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tabla_informe5  tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });


        $("#buscar6").on("keyup", function () {
            var value = $(this).val().toLowerCase();
            $("#tabla_informe6  tr").filter(function () {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
    });

    



}



function cargar_toggles_ot() {
    $('#chkToggle2').change(function () {
        if ($(this).prop("checked") == true) {
            $('#condicion_ot').val('P44444402');
            $("#cbox_origen").prop('required', true);
            $("#cbox_tipo_problem").prop('required', false);
            $("#cbox_maquina").prop('required', false);
            $("#div_fecha_log").show();

            $('#div_proveedor').hide();
            $('#cbox_maquina option').prop('selected', function () {
                return this.defaultSelected;
            });
            $('#id_categoria option').prop('selected', function () {
                return this.defaultSelected;
            });
        }
        else {
            $("#div_fecha_log").hide();

            $('#condicion_ot').val('P44444401');
            $("#cbox_origen").prop('required', true);
            $("#cbox_tipo_problem").prop('required', true);
            $("#cbox_maquina").prop('required', true);
            $('#div_proveedor').show();

        }
    });


}

function buscar_maquina_area() {
    var id = $('#cbox_origen').val();

    $.ajax({
        type: "POST",
        url: ruta_consultas+'combo_maquina.aspx',
        data: ({ id: id }),
        beforeSend: function () {

        },
        success: function (res) {

            $("#cbox_maquina").html(res.combo);
            $("#div_maquina").show();
        }
    });



}

function filtrar_sub_categoria() {
    var id = $('#cbox_maquina').val();
    $.ajax({
        type: "POST",
        url: ruta_consultas +'combo_articulo.aspx',
        data: ({ id: id }),
        beforeSend: function () {

        },
        success: function (res) {

            $("#id_categoria").html(res.combo);
        }
    });

}

function validar_envio(perfil) {


    $('#form_ot').on('submit', function (e) {
        e.preventDefault(); var maquina = $('#txt_olean_maquina').val();

        Swal.fire({
            title: 'REGISTRO DE PEDIDO DE TRABAJO',
            text: "DESEA REGISTRAR LOS DATOS INGRESADOS?",
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'SI, REGISTRAR!',
            cancelButtonText: 'NO, CANCELAR!'
        }).then((result) => {
            if (result.value) {

                enviar_datos_ot(perfil);
            }
        })

    });
}