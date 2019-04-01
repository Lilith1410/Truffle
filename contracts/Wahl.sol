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

  //Initialisierung der Wahl
  /**
   * Konstruktor.  
   */
  constructor () public {
    wahlleiter = msg.sender;
    status = WahlStatus.initialisieren;
    stimmenAnzahl = 1;
  }

  /**
   * Setzt die Anzahl der Stimmen, die ein Wähler vergeben kann.
   */
  function setStimmenAnzahl(uint256 _stimmenAnzahl) public returns(bool) {
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      stimmenAnzahl = _stimmenAnzahl;
      return true;
    }
    return false;
  }

  /**
   * Fügt einen Schlüssel (Codeword als String) hinzu, den ein Wähler benötigt, um zu wählen
   */
  function addWaehler(string memory key) public returns(bool) {
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      waehlerKeys[key] = true;
      return true;
    }
    return false;
  }

  /**
   * Füft eine Wahloption hinzu. Dies kann eine Person, aber auch etwas anderes sein.
   */
  function addOption(string memory option) public returns(bool) {
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      vergebeneStimmen[option] = 0;
      return true;
    }
    return false;
  }

  //Durchführen der Wahl
  /**
   * Mit dieser Methode wird die Wahl gestartet. Dies bedeutet, dass die 
   * Initialisiations-Funktionen nicht mehr funktionieren und es möglich
   * ist, Stimmen abzugeben.
   */
  function wahlStarten() public returns(bool){
    if(msg.sender == wahlleiter&&status == WahlStatus.initialisieren){
      status = WahlStatus.laeuft;
      return true;
    }
    return false;
  }

  /**
   * Fügt den Account eines Wählers in das Wahlregister ein.
   * Dazu muss ein vorher eingestellter Schlüssel angegeben werden.
   * Der Schlüssel kann nur einmal verwendet werden.
   */
  function identify(string memory key) public returns(bool){
    if(waehlerKeys[key] == true&&status == WahlStatus.laeuft){
      //wenn ja
      vergebbareStimmen[msg.sender] = stimmenAnzahl;
      waehlerKeys[key] = false;
      return true;
    }
    return false;
  }

  /**
   * Diese Methode ist für einen Wähler gedacht und vergibt eine Stimme
   * für die angegebene Option.
   *
   * TODO: Was passiert bei Angabe einer falschen Option?
   */
  function waehle(string memory option) public returns(bool) {
    if(vergebbareStimmen[msg.sender] >= 1&&status == WahlStatus.laeuft){
      vergebbareStimmen[msg.sender] -= 1;
      vergebeneStimmen[option] += 1;
      return true;
    }
    return false;
  }
  
  /**
   * Diese Methode ist für einen Wähler gedacht und vergibt _stimmanAnzahl viele
   * Stimmen an die  gewählte Option.
   *
   * TODO: Was passiert bei Angabe einer falschen Option?
   */
  function waehle(string memory option, uint256 _stimmenAnzahl) public returns(bool) {
    if(vergebbareStimmen[msg.sender] >= _stimmenAnzahl&&status == WahlStatus.laeuft){
      vergebbareStimmen[msg.sender] -= _stimmenAnzahl;
      vergebeneStimmen[option] += _stimmenAnzahl;
      return true;
    }
    return false;
  }

  //Ende der Wahl
  /**
   * Diese Methode beendet die Wahl und schaltet das Auslesen der Ergebnisse frei.
   * Achtung: Die Ergebnisse sind vorher schon in der Blockchain gespeichert und
   * können - wenn auch mit etwas mehr Aufwand als durch die Methode getResults()
   * - dort ausgelesen werden.
   */
  function wahlBeenden() public returns(bool){
  	if(msg.sender == wahlleiter){
      status = WahlStatus.beendet;
      return true;
    }
    return false;
  }


  /**
   * Gibt die Anzahl der Stimmen, die für die Option option abgegeben worden sind,
   * zurück.
   */
  function getResults(string memory option) public view returns(uint256){
    if(status == WahlStatus.beendet){
      return vergebeneStimmen[option];
    }
    return 0;
  }
}