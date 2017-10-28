module Main exposing (..)

import Functions exposing (..)
import Html exposing (Html, button, div, form, label, li, text)
import Html.Events exposing (onClick)
import Time exposing (Time, millisecond)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (millisecond * 100) Tick


type Resource
    = Food
    | Water
    | Energy
    | Health


type alias Model =
    { resources : List Resource
    }


init : ( Model, Cmd Msg )
init =
    { resources = [] } ! []


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            model ! []


view : Model -> Html Msg
view model =
    div [] []
