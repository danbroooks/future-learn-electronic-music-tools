port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)

type alias Model =
  { osc : Bool
  , pitch : Pitch
  }

type alias Pitch = Int

initialModel : Model
initialModel =
  { osc = False
  , pitch = 200
  }

init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

type Msg
  = Start
  | Stop
  | AlterPitch Pitch

port start : () -> Cmd msg

port stop : () -> Cmd msg

port pitch : Pitch -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Start ->
      ({ model | osc = True }, start ())
    Stop ->
      ({ model | osc = False }, stop ())
    AlterPitch p ->
      ({ model | pitch = p }, pitch p)

view : Model -> Html Msg
view model =
  div [ class "app" ]
    [ div [ class "unit unit--red" ]
      [ redToggleButton model.osc <| [ text "Osc" ]
      , pitchSlider model.pitch
      ]
    ]

redToggleButton : Bool -> List (Html Msg) -> Html Msg
redToggleButton on =
  button [ class <| toggleClass on
         , onClick <| toggleEvent on
         ]

pitchSlider : Pitch -> Html Msg
pitchSlider pitch =
  div [ class "pitch-slider"
      , on "mousemove" <| Json.map pitchSlideHandler (field "offsetY" int) ] []

pitchSlideHandler : Int -> Msg
pitchSlideHandler x = AlterPitch (400 - x)

toggleClass : Bool -> String
toggleClass on =
  if on then "toggle toggle--red toggle--enabled"
        else "toggle toggle--red"

toggleEvent : Bool -> Msg
toggleEvent on =
  if on then Stop else Start

main : Program Never Model Msg
main =
  Html.program
    { view = view
    , init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    }
