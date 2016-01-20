module Sample where

import Effects exposing (Effects)
import Html exposing (..)
import TransitRouter


type Action
    = NoOp
    | RouterAction TransitRouter.Action


init : (Model, Effects Action)
init =
    ( { }
    , Effects.none
    )


update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        NoOp ->
            ( model, Effects.none )


view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ text "Hello World!" ]
