// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract notas{
    
    // Direccion del profesor
    address public profesor;
    
    constructor() public {
        profesor = msg.sender;
    }
    
    // Relacion identidad alumno con su nota
    mapping (bytes32 => uint) Notas;
    
    // Alumnos que piden revisiones
    string [] revisiones;
    
    // Eventos
    event alumno_evaluado(bytes32);
    event alumno_revision(string);
    
    // Funcion de evaluacion a alumnos
    function Evaluar(string memory _idAlumno, uint _nota) public SolamenteProfesor(msg.sender){
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        Notas[hash_idAlumno] = _nota;
        emit alumno_evaluado(hash_idAlumno);
    }
    
    //Agregamos validacion de solo profesor
    modifier SolamenteProfesor (address _direccion){
        // Validamos que el profesor sea el owner
        require(_direccion == profesor, "No tienes permisos para ejecutar la evaluación");
        _;
    }
    
    function VerNotas(string memory _idAlumno) public view returns(uint){
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        uint notaAlumno = Notas[hash_idAlumno];
        return notaAlumno;
    }
    
    //El alumno puede solicitar una revision de su nota.
    function Revision(string memory _idAlumno) public{
        revisiones.push(_idAlumno);
        emit alumno_revision(_idAlumno);
    }
    
    //Devolvemos identidades de alumnos que solicitaron revision.
    function VerRevisiones() public view SolamenteProfesor(msg.sender) returns(string [] memory){
        return revisiones;
    }
}
