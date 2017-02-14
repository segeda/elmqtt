port module Main exposing (main)

import Html exposing (Html, h1, div, dl, dt, dd, text)
import Html.Attributes exposing (class)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    Payload


type alias Payload =
    { humidity : Int
    , temperature : Int
    , heatIndex : Float
    }


init : ( Model, Cmd Msg )
init =
    ( Payload 0 0 0.0, Cmd.none )



-- UPDATE


type Msg
    = OnMessage Payload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMessage payload ->
            ( payload, Cmd.none )



-- SUBSCRIPTIONS


port onMessage : (Payload -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    onMessage OnMessage



-- VIEW


view : Model -> Html Msg
view model =
    let
        humidityClass =
            if (40 <= model.humidity) && (model.humidity <= 55) then
                "ok"
            else
                "bad"
    in
        div []
            [ h1 [] [ text "Elm and MQTT" ]
            , dl []
                [ dt [ class humidityClass ] [ text "humidity" ]
                , dd [ class humidityClass ]
                    [ text (toString model.humidity)
                    , text "%"
                    ]
                , dt [] [ text "temperature" ]
                , dd []
                    [ text (toString model.temperature)
                    , text "°C"
                    ]
                , dt [] [ text "heatIndex" ]
                , dd []
                    [ text (toString model.heatIndex)
                    , text "°C"
                    ]
                ]
            ]
