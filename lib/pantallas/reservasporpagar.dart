
// ignore_for_file: avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/displaytarjetas.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';

class ReservasPorPagar extends StatefulWidget {
  const ReservasPorPagar({super.key});

  @override
  State<ReservasPorPagar> createState() => _ReservasPorPagar();
}

class _ReservasPorPagar extends State<ReservasPorPagar> {

  @override
  Widget build(BuildContext context) {        
    userCollection = db.collection(USER_COLLECTION3);
    

    return Scaffold(
      appBar: AppBar (
        title : const Text('Reservas Por Pagar'),
        centerTitle: true,
        backgroundColor:Colors.blueGrey ,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
      bottom: const PreferredSize(
      preferredSize: Size.fromHeight(80.0), 
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'Aqui Podras ver las reservas\naprobadas por el Hotel\ndisponibles para pago',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
      ),
      
      body : Container(
        
      child:SafeArea(
            child: Padding(
              
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future : MongoDatabase.getDataReservasPorPagar(),
                builder: (context, AsyncSnapshot snapshot) {
                 if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                 }else{
                  if(snapshot.hasData){
                    var totalData = snapshot.data.length;
                    
                    return ListView.builder(
                      itemCount: totalData,
                      itemBuilder: (context,index){
                        
                          return displayCard(
                            MongoReservaHabitaciones.fromJson(snapshot.data[index]),context );
                      }
                      ); 
                  }else{
                    return const Center(
                      child: Text("No hay datos"),
                    );
                  }
                 }
                }, 
              ),
            ),
        ),
      ),
      );
  }
  
 
 
}

Widget displayCard(MongoReservaHabitaciones data,BuildContext context){
   Future<void> _deleteReserva(var ids,String habitacion,String usuario,String fechainicio,
   String fechafinal, String namereservador, String idreservador,  String personas, String precio,BuildContext context)async {
    final updatedata=MongoReservaHabitaciones(id:ids , habitacion: habitacion,
     usuario: usuario, fechainicio: fechainicio, fechafinal: fechafinal,
      namereservador: namereservador, 
      idreservador: idreservador, 
      estado: 'Pagado', 
      personas: personas,
       precio: precio);
       
       await MongoDatabase.deleteReserva(updatedata).whenComplete(
        
        () => Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return const PantallaInicio();
                    },
                   
                    )));

   } 
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Pagar:"),
                  IconButton(onPressed: (){
                routeName="pagar";
               Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return const displayTarjetas();
                    },
                    settings: RouteSettings(arguments: data)
                    ));
              }, icon: const Icon(Icons.payment),color: Colors.white,iconSize: 40),
              const SizedBox(width: 20,),
              const Text("Eliminar:"),

              IconButton(onPressed: (){
                _deleteReserva(data.id, data.habitacion, 
                data.usuario, data.fechainicio, data.fechafinal,
                 data.namereservador, data.idreservador,
                  data.personas, data.precio, context);
               
              }, icon: const Icon(Icons.delete_forever),color: Colors.white,iconSize: 40,),
                ],
              ),
              
              Text("Habitacion: ${data.habitacion}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("Estado :${data.estado}", style: const TextStyle(fontWeight: FontWeight.bold )),
               const SizedBox(height: 5,),
              Text("Fecha Inicio : ${data.fechainicio}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
             Text("Fecha Final : ${data.fechafinal}", style: const TextStyle(fontWeight: FontWeight.bold )),
            const SizedBox(height: 5,),
             Text("A nombre de: ${data.namereservador}", style: const TextStyle(fontWeight: FontWeight.bold )),
            const SizedBox(height: 5,),
             Text("ID: ${data.idreservador}", style: const TextStyle(fontWeight: FontWeight.bold )),
             const SizedBox(height: 5,),
             Text("Personas: ${data.personas}", style: const TextStyle(fontWeight: FontWeight.bold )),
             const SizedBox(height: 5,),
             Text("Precio HNL: ${data.precio}", style: const TextStyle(fontWeight: FontWeight.bold )),
              
          
            ],
          ),
         
        
      ),
    );
    
}