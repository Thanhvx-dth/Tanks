using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

namespace BattleCity.Player
{
    public class Left : MonoBehaviour
    {

        public static bool enable;
        void Awake()
        {
            enable = false;
        }
        public void OnPointerEnter(BaseEventData eventData)
        {
            enable = true;
            // Left.enable = false;
            Top.enable = false;
            Bot.enable = false;
            Right.enable = false;
        }

        public void OnPointerDeselect(BaseEventData eventData)
        {
            enable = false;
        }
    }
}
