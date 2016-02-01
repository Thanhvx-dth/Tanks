using System;
using UnityEngine;

namespace BattleCity.Player
{
	public class ShootingPlayer : Shooting
	{
		[SerializeField]
		private Parameters[] ParamsUpgrade;

		[Header("Sounds")]
		[SerializeField]
		private AudioClip AudioShot;

		private PlayerController _playerController;
		private string _buttonNameFire;
        public static bool fire;
		protected override void Awake()
		{
			_playerController = GetComponent<PlayerController>();
			_playerController.UpgradeEvent += SetParameters;
			_buttonNameFire = _playerController.TypeItem + "_Fire";
            fire = false;
            base.Awake();
		}
        
		private void FixedUpdate()
		{
			if (_playerController.EditorMode)
				return;
			if(fire) //(Input.GetButton(_buttonNameFire))
			{
                fire = false;
				if (RunBullet())
					AudioManager.PlaySecondarySound(AudioShot);
			}
		}

		private void SetParameters(int index)
		{
			if (index < 0)
				return;
			if (index >= ParamsUpgrade.Length)
				return;

			SpeedBullet = ParamsUpgrade[index].SpeedBullet;
			MaxBullet = ParamsUpgrade[index].MaxBullet;
			ShotDelay = ParamsUpgrade[index].ShotDelay;
			ArmorPiercing = ParamsUpgrade[index].ArmorPiercing;
		}

		[Serializable]
		public class Parameters
		{
			public float SpeedBullet;
			public int MaxBullet;
			public float ShotDelay;
			public bool ArmorPiercing;
		}
	}
}