﻿using BattleCity.GUI.Main;
using System;
using System.Collections;
using UnityEngine;

namespace BattleCity
{
	public class GameManager : MonoBehaviour
	{
		[SerializeField]
		private Canvas Black;
		[SerializeField]
		private int _startLifePlayer1 = 2;
		[SerializeField]
		private int _startLifePlayer2 = 2;

		public static bool Pause
		{
			get
			{
				return _instance._pause;
			}
			set
			{
				if (_instance._gameOver)
					return;
				if (value)
				{
                    Time.timeScale = 0;
					GameGUIController.Instance.ShowPause();
				}
				else
				{
					Time.timeScale = _instance._defaultTimeScale;
					GameGUIController.Instance.HidePause();
				}
				_instance._pause = value;
			}
		}
		public static bool SinglePlayer { get; private set; }
		public static int Player1Life
		{
			get
			{
				return _instance._player1Life;
			}
			set
			{
				if (value < _instance._player1Life)
					Player1.Upgrade = 0;
				_instance._player1Life = value;
				if (value < 0)
				{
					if (SinglePlayer || Player2Life < 0)
						GameOver();
					else
						GameGUIController.Instance.ShowGameOverPlayer1((s, e) =>
						{
							_instance.StartCoroutine(_instance.HideGameOverPlayer(1));
						});
					return;
				}
				GameGUIController.Instance.Player1LifeCount = value;
			}
		}
		public static PlayerData Player1;
		public static int Player2Life
		{
			get
			{
				return _instance._player2Life;
			}
			set
			{
				if (value < _instance._player2Life)
					Player2.Upgrade = 0;
				_instance._player2Life = value;
				if (value < 0)
				{
					if (Player1Life < 0)
						GameOver();
					else
						GameGUIController.Instance.ShowGameOverPlayer2((s, e) =>
						{
							_instance.StartCoroutine(_instance.HideGameOverPlayer(2));
						});
					return;
				}
				GameGUIController.Instance.Player2LifeCount = value;
			}
		}
		public static PlayerData Player2;
		public static int HiScore { get; set; }

		private static GameManager _instance;
		private float _defaultTimeScale;
		private bool _pause;
		private bool _gameOver;
		private int _player1Life;
		private int _player2Life;

		public void LoadApplication()
		{
			Black.gameObject.SetActive(false);
			HiScore = PlayerPrefs.GetInt("HiScore", Consts.DefaultHighScore);
			MainMenuController.Show(0, 0);
		}

		public static void StartGame(bool singlePlayer, EventHandler overlapScreen)
		{
			AudioManager.EnablePlayerSound = true;
			AudioManager.EnableSecondarySound = true;

			SinglePlayer = singlePlayer;

			Player1.Score = 0;
			Player1.LifeScore = 0;
			Player1.Upgrade = 0;
			Player1.ResetEnemy();
			Player1Life = _instance._startLifePlayer1;

			Player2.Score = 0;
			Player2.LifeScore = 0;
			Player2.Upgrade = 0;
			Player2.ResetEnemy();
			Player2Life = _instance._startLifePlayer2;
			if (SinglePlayer)
				GameGUIController.Instance.HidePlayer2Life();

			_instance.StartCoroutine(_instance.NextLevel(overlapScreen, true));
		}

		public static void NextLevel(EventHandler overlapScreen)
		{
			AudioManager.EnablePlayerSound = false;
			_instance.StartCoroutine(_instance.NextLevel(overlapScreen, false));
		}

		private IEnumerator NextLevel(EventHandler overlapScreen, bool skipCalcScore)
		{
			Reset();
			if (!skipCalcScore)
			{
				var loop = true;
				ScoreGUIController.Show((s, e) => { loop = false; },
					LevelManager.LevelNumber, Player1, Player2);
				while (loop)
					yield return null;
				yield return new WaitForSeconds(1.5f);

				if (overlapScreen == null)
					overlapScreen = (s, e) => { ScoreGUIController.Hide(); };
				else
					overlapScreen += (s, e) => { ScoreGUIController.Hide(); };
			}
			StartCoroutine(NextLevelLoadScreen(overlapScreen));
		}

		public static void GameOver()
		{
			if (_instance._gameOver)
				return;
			_instance._gameOver = true;
			AudioManager.EnablePlayerSound = false;
			AudioManager.EnableSecondarySound = false;

			_instance.StartCoroutine(_instance.ShowGameOver());
		}

		private IEnumerator NextLevelLoadScreen(EventHandler overlapScreen)
		{
			var defaultScale = Time.timeScale;
			Time.timeScale = 0;

			var loop = true;
			var level = LevelManager.LevelNumber + 1;

			LoadLevelSceneController.Show(level, (s, e) => { loop = false; }, null);
			while (loop)
				yield return null;

			if (overlapScreen != null)
				overlapScreen(this, EventArgs.Empty);

			yield return new WaitForSecondsRealtime(1f);
			LevelManager.NextLevel();
			yield return new WaitForSecondsRealtime(1f);

			loop = true;
			LoadLevelSceneController.Hide((s, e) => { loop = false; });
			while (loop)
				yield return null;

			Time.timeScale = defaultScale;
			SpawnPointEnemiesManager.StartSpawn();
			Player1.ResetEnemy();
			Player2.ResetEnemy();
		}

		private IEnumerator ShowGameOver()
		{
			var player = FieldController.Instance.FindBlock(Block.Player1);
			if (player != null)
				player.EditorMode = true;

			player = FieldController.Instance.FindBlock(Block.Player2);
			if (player != null)
				player.EditorMode = true;

			// Show GameOver in game
			GameGUIController.Instance.ShowGameOver();
			yield return new WaitForSeconds(5);

			Reset();

			// Show calc score
			AudioManager.EnableSecondarySound = true;
			var loop = true;
			ScoreGUIController.Show((s, e) => { loop = false; },
				LevelManager.LevelNumber, Player1, Player2);
			while (loop)
				yield return null;
			ScoreGUIController.Hide();

			// Show final screen with GameOver
			FinalScreenController.Show();
			yield return new WaitForSeconds(3);
			FinalScreenController.Hide();
			

			LevelManager.Reset();
			MainMenuController.Show(Player1.Score, Player2.Score);
		}

		private void Reset()
		{
			_gameOver = false;
			_pause = false;

			SpawnPointEnemiesManager.Reset();
			GameGUIController.Instance.HidePause();
			GameGUIController.Instance.HideGameOver();
			GameGUIController.Instance.HideGameOverPlayer1();
			GameGUIController.Instance.HideGameOverPlayer2();
			FieldController.Instance.Clear();
		}

		private void Awake()
		{
			_instance = this;
			_defaultTimeScale = Time.timeScale;
			Black.GetComponent<Canvas>().renderMode = RenderMode.ScreenSpaceOverlay;

			Player1.ChangeScoreEvent += Player1_ChangeScoreEvent;
			Player2.ChangeScoreEvent += Player2_ChangeScoreEvent;
		}

		private void Player1_ChangeScoreEvent(int score)
		{
			if (score - Player1.LifeScore < Consts.ScoreForLife)
				return;

			var life = Mathf.FloorToInt((float)score / Consts.ScoreForLife);
			Player1Life += life;
			Player1.LifeScore = score;

		}

		private void Player2_ChangeScoreEvent(int score)
		{
			if (score - Player2.LifeScore < Consts.ScoreForLife)
				return;

			var life = Mathf.FloorToInt((float)score / Consts.ScoreForLife);
			Player2Life += life;
			Player2.LifeScore = score;

		}

		private IEnumerator HideGameOverPlayer(int playerNumber)
		{
			yield return new WaitForSeconds(5);

			if (playerNumber == 1)
				GameGUIController.Instance.HideGameOverPlayer1();
			else if (playerNumber == 2)
				GameGUIController.Instance.HideGameOverPlayer2();
			else
			{
				GameGUIController.Instance.HideGameOverPlayer1();
				GameGUIController.Instance.HideGameOverPlayer2();
			}
		}
	}
}