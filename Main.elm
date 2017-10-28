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
    Time.every (millisecond * 100) Tick


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
    , ct : Float
    }


init : ( Model, Cmd Msg )
init =
    { resources = []
    , ct = 0
    , mdl = Material.model
    }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            { model | ct = model.ct + 1 }
                ! []

        Increase ->
            { model | ct = model.ct + 10 }
                ! []

        Reset ->
            { model | ct = 0 }
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
        [ style [ ( "padding", "2rem" ) ] ]
        [ text ("Current count: " ++ toString model.ct)

        {- We construct the instances of the Button component that we need, one
           for the increase button, one for the reset button. First, the increase
           button. The first three arguments are:
             - A Msg constructor (`Mdl`), lifting Mdl messages to the Msg type.
             - An instance id (the `[0]`). Every component that uses the same model
               collection (model.mdl in this file) must have a distinct instance id.
             - A reference to the elm-mdl model collection (`model.mdl`).
           Notice that we do not have to add fields for the increase and reset buttons
           separately to our model; and we did not have to add to our update messages
           to handle their internal events.
           Mdl components are configured with `Options`, similar to `Html.Attributes`.
           The `Options.onClick Increase` option instructs the button to send the `Increase`
           message when clicked. The `css ...` option adds CSS styling to the button.
           See `Material.Options` for details on options.
        -}
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick Increase
            , css "margin" "0 24px"
            ]
            [ text "Increase" ]
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick Reset ]
            [ text "Reset" ]
        , Loading.progress (loadingFunction model.ct)
        ]
        |> Material.Scheme.top
