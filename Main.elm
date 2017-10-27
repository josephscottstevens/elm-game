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
    { wood : Float
    , stone : Float
    , gold : Float
    , mines : Float
    , goldmines : Float
    , lumbercamps : Float
    , priceMine : Float
    , priceLumberCamp : Float
    , priceGoldmines : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { wood = 0, stone = 0, gold = 0, mines = 0, lumbercamps = 0, goldmines = 0, priceMine = 10, priceLumberCamp = 10, priceGoldmines = 10 }, Cmd.none )


type Msg
    = MineWood
    | MineStone
    | MineGold
    | Tick Time
    | BuildLumberCamp
    | BuildMine
    | BuildGoldmines


lumbercampsBtn : Model -> Html Msg
lumbercampsBtn model =
    if model.wood >= model.priceLumberCamp || model.lumbercamps > 0 then
        button [ onClick BuildLumberCamp ] [ text ("build lumbercamp (costs: " ++ toString model.priceLumberCamp ++ ")") ]
    else
        div [] []


minesBtn : Model -> Html Msg
minesBtn model =
    if model.stone >= model.priceMine || model.mines > 0 then
        button [ onClick BuildMine ] [ text ("build mine (costs: " ++ toString model.priceMine ++ ")") ]
    else
        div [] []


goldminesBtn : Model -> Html Msg
goldminesBtn model =
    if model.gold >= model.priceGoldmines || model.goldmines > 0 then
        button [ onClick BuildGoldmines ] [ text ("build Goldmine (costs: " ++ toString model.priceGoldmines ++ ")") ]
    else
        div [] []


buildLumberCamp : Model -> Model
buildLumberCamp model =
    if model.wood > model.priceLumberCamp then
        { model
            | lumbercamps = model.lumbercamps + 1
            , wood = model.wood - model.priceLumberCamp
            , priceLumberCamp = model.priceLumberCamp * 2
        }
    else
        model


buildMine : Model -> Model
buildMine model =
    if model.stone > model.priceMine then
        { model
            | mines = model.mines + 1
            , stone = model.stone - model.priceMine
            , priceMine = model.priceMine * 2
        }
    else
        model


buildGoldmines : Model -> Model
buildGoldmines model =
    if model.gold > model.priceGoldmines then
        { model
            | goldmines = model.goldmines + 1
            , gold = model.gold - model.priceGoldmines
            , priceGoldmines = model.priceGoldmines * 2
        }
    else
        model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MineWood ->
            ( { model | wood = model.wood + 1 }, Cmd.none )

        MineStone ->
            ( { model | stone = model.stone + 1 }, Cmd.none )

        MineGold ->
            ( { model | gold = model.gold + 1 }, Cmd.none )

        BuildLumberCamp ->
            ( buildLumberCamp model, Cmd.none )

        BuildMine ->
            ( buildMine model, Cmd.none )

        BuildGoldmines ->
            ( buildGoldmines model, Cmd.none )

        Tick newTime ->
            ( { model
                | wood = model.wood + model.lumbercamps
                , goldmines = model.gold + model.goldmines
                , stone = model.stone + model.mines
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ text ("You have: " ++ toString model.wood ++ " wood")
            , div [] [ text ("You have: " ++ toString model.stone ++ " stone") ]
            , div [] [ text ("You have: " ++ toString model.gold ++ " gold") ]
            ]
        , div []
            [ button [ onClick MineWood ] [ text "Mine Wood" ]
            , button [ onClick MineStone ] [ text "Mine Stone" ]
            , button [ onClick MineGold ] [ text "How do I mine for fish?" ]
            ]
        , div []
            [ text ("you have " ++ toString model.lumbercamps ++ " lumbercamps")
            , text ("you have " ++ toString model.stone ++ " stone")
            , text ("you have " ++ toString model.mines ++ " mines")
            ]
        , lumbercampsBtn model
        , minesBtn model
        , goldminesBtn model
        ]
