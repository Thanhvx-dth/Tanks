using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

namespace BattleCity.Player
{
    public class Fire : MonoBehaviour
    {

        public void OnPointerEnter(BaseEventData eventData)
        {
            ShootingPlayer.fire = true;
        }
    }
}