module Main exposing (..)

import Functions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Material
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Progress as Loading
import Material.Scheme
import Material.Spinner as Loading
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
    Time.every (millisecond * 1000) Tick


type Resource
    = Food
    | Water
    | Energy
    | Health


type Msg
    = Tick Time
    | Mdl (Material.Msg Msg)
    | Increase
    | Reset


type alias Model =
    { resources : List Resource
    , mdl : Material.Model
    , exploreProgress : Float
    , exploreSpeed : Float
    }


init : ( Model, Cmd Msg )
init =
    { resources = []
    , exploreProgress = 0
    , exploreSpeed = 10
    , mdl = Material.model
    }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            { model | exploreProgress = model.exploreProgress + model.exploreSpeed }
                ! []

        Increase ->
            model ! []

        Reset ->
            { model | exploreProgress = 0 }
                ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model


type alias Mdl =
    Material.Model


loadingFunction : Float -> Float
loadingFunction t =
    if t >= 100.0 then
        100.0
    else
        t


view : Model -> Html Msg
view model =
    div
        [ style [ ( "display", "grid" ), ( "grid-template-columns", "1fr 1fr 1fr" ) ] ]
        [ div []
            [ div [] [ text "resources" ]
            , Button.render Mdl
                [ 0 ]
                model.mdl
                [ Options.onClick Increase
                , css "margin" "0 24px"
                ]
                [ text "Increase" ]
            ]
        , div []
            [ div [] [ text "actions" ]
            , Button.render Mdl
                [ 1 ]
                model.mdl
                [ Options.onClick Reset ]
                [ text "Reset" ]
            ]
        , div []
            [ div [] [ text "explore" ]
            , Loading.progress (loadingFunction model.exploreProgress)
            ]
        ]
        |> Material.Scheme.top
