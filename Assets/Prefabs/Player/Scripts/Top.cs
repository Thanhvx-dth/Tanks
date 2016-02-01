using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

namespace BattleCity.Player
{
    public class Top : MonoBehaviour
    {

        public static bool enable;

        public void OnPointerEnter(BaseEventData eventData)
        {
            enable = true;
            Left.enable = false;
            Bot.enable = false;
            Right.enable = false;
        }

        public void OnPointerDeselect(BaseEventData eventData)
        {
            enable = false;
        }
    }
}
