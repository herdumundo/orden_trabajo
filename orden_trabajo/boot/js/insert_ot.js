
function filtrar() {
    var id = document.getElementById("txt_test").value
    var actualiza_parte = new XMLHttpRequest();
    actualiza_parte.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            var response = this.responseText;
            document.getElementById("div_maquina").innerHTML = response;
        }
    };
    actualiza_parte.open("GET", "combo_maquina.aspx?id=" + id + "", true);
    actualiza_parte.send();
    $("#div_maquina").show();
}

function filtrar_sub_categoria() {
    var id = document.getElementById("cbox_maquina").value
    var actualiza_parte = new XMLHttpRequest();
    actualiza_parte.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            var response = this.responseText;
            document.getElementById("sub_categoria").innerHTML = response;
        }
    };
    actualiza_parte.open("GET", "combo_articulo.aspx?id=" + id + "", true);
    actualiza_parte.send();
    $("#sub_categoria").show();
}

function meter_valores_en_txt() {
    var text;
    text = $('#cbox_origen').val();
    $('#txt_test').val(text);
}


function validar_envio(perfil) {
    var maquina = $('#txt_olean_maquina').val();
    var problema = $('#txt_bproblema').val();
    var descripcion = $('#description').val();

    if (maquina == '-' || problema == "" || descripcion == "") {

        alert('ERROR,CARGAR DATOS');
    }

    else {


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
    }
}
