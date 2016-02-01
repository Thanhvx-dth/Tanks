using System;
using UnityEngine;

namespace BattleCity
{
	public class DestructionWall : MonoBehaviour, IDestroy
	{
		[SerializeField]
		private bool NotDestruction;
	

		public event EventHandler DestroyEvent;

		public void ClearEvent()
		{
			DestroyEvent = null;
		}

		protected virtual void OnTriggerEnter2D(Collider2D other)
		{
			if (other.tag == "Bullet")
			{
				var bullet = other.GetComponent<BulletController>();
				if (bullet == null)
					return;


				if (bullet.ArmorPiercing && !NotDestruction)
				{
					
					Destroy(gameObject);
				}			
			}
		}

		protected virtual void OnDestroy()
		{
			if (DestroyEvent != null)
				DestroyEvent(this, null);
		}

		protected virtual void OnApplicationQuit()
		{
			DestroyEvent = null;
		}
	}
}