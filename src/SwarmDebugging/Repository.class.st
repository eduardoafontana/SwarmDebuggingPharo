Class {
	#name : #Repository,
	#superclass : #Object,
	#category : #SwarmDebugging
}

{ #category : #action }
Repository class >> save: dataObject [

|jsonData|
jsonData := String streamContents: [ :stream | 
   (NeoJSONWriter on: stream)
      prettyPrint: true;
      mapInstVarsFor: SessionData;
      nextPut: (dataObject) ].

ZnClient new
   url: 'http://swarmserver.azurewebsites.net/api/session';
   entity: (ZnEntity
               with: jsonData 
               type: ZnMimeType applicationJson);
   post.
]
