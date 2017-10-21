module Main exposing (..)

import Html exposing (Html, button, div, form, label, li, text)
import Html.Events exposing (onClick)
import Time exposing (Time, second)


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
    Time.every second Tick


type alias Model =
    { wood : Int
    , stone : Int
    , mines : Int
    , lumbercamps : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { wood = 0, stone = 0, mines = 0, lumbercamps = 0 }, Cmd.none )


type Msg
    = MineWood
    | MineStone
    | Tick Time
    | BuildLumberCamp
    | BuildMine


lumbercamps : Model -> Html Msg
lumbercamps model =
    if model.wood > 10 || model.lumbercamps > 0 then
        button [ onClick BuildLumberCamp ] [ text "build lumbercamp" ]
    else
        div [] []


mines : Model -> Html Msg
mines model =
    if model.stone > 10 || model.mines > 0 then
        button [ onClick BuildMine ] [ text "build mine" ]
    else
        div [] []


buildLumberCamp : Model -> Model
buildLumberCamp model =
    if model.wood > 10 then
        { model | lumbercamps = model.lumbercamps + 1, wood = model.wood - 10 }
    else
        model


buildMine : Model -> Model
buildMine model =
    if model.stone > 10 then
        { model | mines = model.mines + 1, stone = model.stone - 10 }
    else
        model


showMines : Model -> Html msg
showMines model =
    if model.mines > 0 then
        div [] [ text ("you have " ++ toString model.mines ++ " mines") ]
    else
        div [] []


showLumbercamps : Model -> Html msg
showLumbercamps model =
    if model.lumbercamps > 0 then
        div [] [ text ("you have " ++ toString model.lumbercamps ++ " lumbercamps") ]
    else
        div [] []


showManualMine : Model -> Html Msg
showManualMine model =
    div []
        [ text ("You have: " ++ toString model.wood ++ " wood")
        , div [] [ text ("You have: " ++ toString model.stone ++ " stone") ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ showManualMine model
        , button [ onClick MineWood ] [ text "Mine Wood" ]
        , button [ onClick MineStone ] [ text "Mine Stone" ]
        , showMines model
        , showLumbercamps model
        , lumbercamps model
        , mines model
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MineWood ->
            ( { model | wood = model.wood + 1 }, Cmd.none )

        MineStone ->
            ( { model | stone = model.stone + 1 }, Cmd.none )

        BuildLumberCamp ->
            ( buildLumberCamp model, Cmd.none )

        BuildMine ->
            ( buildMine model, Cmd.none )

        Tick newTime ->
            ( { model | wood = model.wood + model.lumbercamps, stone = model.stone + model.mines }, Cmd.none )
