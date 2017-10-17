port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias Model =
  { osc : Bool
  }

initialModel : Model
initialModel =
  { osc = False
  }

init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

type Msg
  = Start
  | Stop

port start : () -> Cmd msg

port stop : () -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Start ->
      ({ model | osc = True }, start ())
    Stop ->
      ({ model | osc = False }, stop ())

view : Model -> Html Msg
view model =
  div [ class "unit unit--red" ]
    [ redToggleButton model.osc <| [ text "Osc" ] ]

redToggleButton : Bool -> List (Html Msg) -> Html Msg
redToggleButton on =
  button [ class <| toggleClass on
         , onClick <| toggleEvent on
         ]

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
