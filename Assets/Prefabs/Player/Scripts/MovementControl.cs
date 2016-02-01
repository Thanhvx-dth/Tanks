using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

namespace BattleCity.Player
{
    public class MovementControl : MonoBehaviour
    {


        public void OnPointerEnter(BaseEventData eventData)
        {

        }

        public void OnPointerDeselect(BaseEventData eventData)
        {
            Left.enable = false;
            Top.enable = false;
            Bot.enable = false;
            Right.enable = false;
        }

    }
}
