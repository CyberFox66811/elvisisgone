package main

// Lowk don't know what these imports do but the example says we need them :sob:

import (
	"fmt"
	"net/http"
	"time"

	"github.com/livekit/protocol/auth"
)

func getToken(w http.ResponseWriter, r *http.Request) {
	// These are the default dev values for the LiveKit Docker image (we can use these until we understand more :sob:)
	apiKey := "devkey"
	apiSecret := "secret"

	// Initialise the token
	at := auth.NewAccessToken(apiKey, apiSecret)

	// Set the user's identity (Must be unique for each user)
	at.SetIdentity("friend_user_1")
	at.SetValidFor(time.Hour)

	// Create the Grant (SetJoinRoom)
	grant := &auth.VideoGrant{
		RoomJoin: true,
		Room:     "my-room", // The name of the room they are joining
	}

	// Attach the grant to the token
	at.AddGrant(grant)

	// Sign it
	token, err := at.ToJWT()
	if err != nil {
		http.Error(w, "Failed to generate token", http.StatusInternalServerError)
		return
	}

	// Send it back
	w.Header().Set("Access-Control-Allow-Origin", "*")
	fmt.Fprint(w, token)
}

func main() {
	http.HandleFunc("/get-token", getToken)
	fmt.Println("Backend is live on http://localhost:8080/get-token")
	http.ListenAndServe(":8080", nil)
}
