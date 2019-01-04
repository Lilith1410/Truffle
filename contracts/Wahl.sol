pragma solidity ^0.5.0;

contract Wahl{
  mapping(address => uint256) vergebbareStimmen;
  mapping(string => uint256) vergebeneStimmen;

  mapping(string => bool) waehlerKeys; //Oder eine Liste | Inhalt: Schlüssel der Wähler

  address wahlleiter;

  enum WahlStatus{
  	initialisieren,
  	laeuft,
  	beendet
  }

  WahlStatus status;

  uint256 stimmenAnzahl;

  //Initialiesierung der Wahl
  constructor () public {
    wahlleiter = msg.sender;
    status = WahlStatus.initialisieren;
    stimmenAnzahl = 1;
  }

  function setStimmenAnzahl(uint256 _stimmenAnzahl) public returns(bool) {
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      stimmenAnzahl = _stimmenAnzahl;
      return true;
    }
    return false;
  }

  function addWaehler(string memory key) public returns(bool) {
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      waehlerKeys[key] = true;
      return true;
    }
    return false;
  }

  function addOption(string memory option) public returns(bool) {
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      vergebeneStimmen[option] = 0;
      return true;
    }
    return false;
  }

  //Durchführen der Wahl
  function wahlStarten() public returns(bool){
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      status = WahlStatus.laeuft;
      return true;
    }
    return false;
  }

  function identify(string memory key) public returns(bool){
    if(waehlerKeys[key] == true&&status == WahlStatus.laeuft){
      //wenn ja
      vergebbareStimmen[msg.sender] = stimmenAnzahl;
      waehlerKeys[key] = false;
      return true;
    }
    return false;
  }

  function waehle(string memory option) public returns(bool) {
    if(vergebbareStimmen[msg.sender] >= 1&&status == WahlStatus.laeuft){
      vergebbareStimmen[msg.sender] -= 1;
      vergebeneStimmen[option] += 1;
      return true;
    }
    return false;
  }
  
  function waehle(string memory option, uint256 _stimmenAnzahl) public returns(bool) {
    if(vergebbareStimmen[msg.sender] >= _stimmenAnzahl&&status == WahlStatus.laeuft){
      vergebbareStimmen[msg.sender] -= _stimmenAnzahl;
      vergebeneStimmen[option] += _stimmenAnzahl;
      return true;
    }
    return false;
  }

  //Ende der Wahl
  function wahlBeenden() public returns(bool){
  	if(msg.sender == wahlleiter){
      status = WahlStatus.beendet;
      return true;
    }
    return false;
  }

  function getResults(string memory option) public view returns(uint256){
    if(status == WahlStatus.beendet){
      return vergebeneStimmen[option];
    }
    return 0;
  }
}
