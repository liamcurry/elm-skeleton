module Main where

import Pages.Home as Home
import Pages.About as About
import Routes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (..)
import Effects exposing (Effects, Never)
import Signal exposing (message)
import StartApp
import TransitRouter exposing (WithRoute, getTransition)
import TransitStyle


type alias Model = WithRoute Route
    { homeModel : Home.Model
    , aboutModel : About.Model
    }


type Action
    = NoOp
    | HomeAction Home.Action
    | AboutAction About.Action
    | RouterAction (TransitRouter.Action Route)


initialModel : Model
initialModel =
    { transitRouter = TransitRouter.empty EmptyRoute
    , homeModel = Home.init
    , aboutModel = About.init
    }


actions : Signal Action
actions =
    Signal.map RouterAction TransitRouter.actions


mountRoute : Route -> Route -> Model -> (Model, Effects Action)
mountRoute prevRoute route model =
    case route of
        Home ->
            (model, Effects.none)
        About ->
            (model, Effects.none)
        EmptyRoute ->
            (model, Effects.none)


routerConfig : TransitRouter.Config Route Action Model
routerConfig =
    { mountRoute = mountRoute
    , getDurations = \_ _ _ -> (50, 200)
    , actionWrapper = RouterAction
    , routeDecoder = decode
    }


init : String -> (Model, Effects Action)
init path =
    TransitRouter.init routerConfig path initialModel


update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        NoOp ->
            (model, Effects.none)

        HomeAction homeAction ->
            let (model', effects) = Home.update homeAction model.homeModel
            in ( { model | homeModel = model' }
                 , Effects.map HomeAction effects )

        AboutAction aboutAction ->
            let (model', effects) = About.update aboutAction model.aboutModel
            in ( { model | aboutModel = model' }
                 , Effects.map AboutAction effects )

        RouterAction routeAction ->
            TransitRouter.update routerConfig routeAction model


-- Main view/layout functions

menu : Signal.Address Action -> Model -> Html
menu address model =
    header
        [ class "navbar navbar-default" ]
        [ div
            [ class "container" ]
            [ div
                [ class "navbar-header" ]
                [ div
                    [ class "navbar-brand" ]
                    [ a (linkAttrs Home) [ text "Home" ]
                    ]
                ]
            , ul
                [ class "nav navbar-nav" ]
                [ li [] [ a (linkAttrs About) [ text "About" ] ] ]
            ]
        ]


contentView : Signal.Address Action -> Model -> Html
contentView address model =
    case (TransitRouter.getRoute model) of
        Home ->
            Home.view (Signal.forwardTo address HomeAction) model.homeModel

        About ->
            About.view (Signal.forwardTo address AboutAction) model.aboutModel

        EmptyRoute ->
            text "Empty WHAT ?"


view : Signal.Address Action -> Model -> Html
view address model =
    div
        [ class "container-fluid" ]
        [ menu address model
        , div
            [ class "content"
            , style (TransitStyle.fadeSlideLeft 100 (getTransition model))
            ]
            [ contentView address model ]
        ]


-- wiring up start app

app : StartApp.App Model
app =
    StartApp.start
        { init = init initialPath
        , update = update
        , view = view
        , inputs = [actions]
        }


main : Signal Html
main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks


port initialPath : String
