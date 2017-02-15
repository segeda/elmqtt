port module Main exposing (main)

import Html exposing (Html, h1, div, dl, dt, dd, ul, li, text)
import Html.Attributes exposing (class)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


loading : String
loading =
    "loading ..."


type alias Model =
    { current : Maybe Payload
    , humidityList : List Humidity
    }


type alias Payload =
    { humidity : Int
    , temperature : Int
    , heatIndex : Float
    , created : Int
    }


type alias Humidity =
    { created : Int
    , value : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing [], Cmd.none )



-- UPDATE


type Msg
    = OnMessage Payload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMessage payload ->
            ( { model
                | current = (Just payload)
                , humidityList = (Humidity payload.created payload.humidity) :: model.humidityList
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


port onMessage : (Payload -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    onMessage OnMessage



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm and MQTT" ]
        , (viewCurrent model.current)
        , (lazy viewHumidityList model.humidityList)
        ]


viewCurrent : Maybe Payload -> Html Msg
viewCurrent current =
    case current of
        Just payload ->
            let
                humidityClass =
                    if (40 <= payload.humidity) && (payload.humidity <= 55) then
                        "ok"
                    else
                        "bad"
            in
                dl []
                    [ dt [ class humidityClass ] [ text "humidity" ]
                    , dd [ class humidityClass ]
                        [ text ((toString payload.humidity) ++ "%") ]
                    , dt [] [ text "temperature" ]
                    , dd []
                        [ text ((toString payload.temperature) ++ "°C") ]
                    , dt [] [ text "heatIndex" ]
                    , dd []
                        [ text ((toString payload.heatIndex) ++ "°C") ]
                    ]

        Nothing ->
            div [] [ text loading ]


viewHumidityList : List Humidity -> Html Msg
viewHumidityList humidityList =
    if not (List.isEmpty humidityList) then
        Keyed.node "ul" [] (List.map viewKeyedHumidity humidityList)
    else
        text loading


viewKeyedHumidity : Humidity -> ( String, Html msg )
viewKeyedHumidity humidity =
    ( (toString humidity.created), lazy viewHumidity humidity )


viewHumidity : Humidity -> Html msg
viewHumidity humidity =
    li []
        [ text ("[" ++ (toString humidity.created) ++ "] " ++ (toString humidity.value)) ]
