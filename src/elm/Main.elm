import Effects exposing (Never)
import StartApp
import Task
import Html exposing (Html)
import Sample exposing (init, update, view, Model)


app : StartApp.App Model
app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs = []
        }


main : Signal Html
main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
