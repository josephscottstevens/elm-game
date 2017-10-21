module Main exposing (..)

import Html exposing (Html, div, form, label, li, text)
import Html.Attributes as Html exposing (for, style)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


type alias Model =
    { wood : Int
    , stone : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { wood = 0, stone = 0 }, Cmd.none )


view : Model -> Html Msg
view model =
    div [] [ text "hello" ]


type Msg
    = Initial


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Initial ->
            ( model, Cmd.none )
