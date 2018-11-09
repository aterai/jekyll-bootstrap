---
layout: post
category: swing
folder: AuditoryCues
title: AuditoryCuesでイベント音を設定する
tags: [UIManager, AuditoryCues, Sound, JOptionPane]
author: aterai
pubdate: 2008-05-26T17:13:17+09:00
description: UIManagerにAuditoryCues.playListを設定して、ダイアログが開いた時の警告音などを鳴らします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHzQ8XbXI/AAAAAAAAARw/-TGnQ_tvnnM/s800/AuditoryCues.png
comments: true
---
## 概要
`UIManager`に`AuditoryCues.playList`を設定して、ダイアログが開いた時の警告音などを鳴らします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHzQ8XbXI/AAAAAAAAARw/-TGnQ_tvnnM/s800/AuditoryCues.png %}

## サンプルコード
<pre class="prettyprint"><code>Object[] optionPaneAuditoryCues = {
  "OptionPane.errorSound", "OptionPane.informationSound",
  "OptionPane.questionSound", "OptionPane.warningSound"
};
//UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.allAuditoryCues"));
//UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.defaultCueList"));
//UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.noAuditoryCues"));
UIManager.put("AuditoryCues.playList", optionPaneAuditoryCues);
</code></pre>

## 解説
上記のサンプルでは、デフォルトではすべて再生しないように設定されている聴覚フィードバックを、`JOptionPane`でダイアログを開いた場合は有効になるように変更しています。

- `showMessageDialog1`
    - `LookAndFeel`デフォルトの音が鳴る(`LookAndFeel`にデフォルトの音が無い場合は鳴らない)
    - `WindowsLookAndFeel`では、「コントロールパネル」「サウンドとオーディオデバイスのプロパティ」で、プログラムイベントが設定されている場合は音が鳴る

<!-- dummy comment line for breaking list -->

- `showMessageDialog2`
    - 別途用意した`wav`ファイルを再生する
    - `UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.noAuditoryCues"))`として、二重に鳴らないように制限

<!-- dummy comment line for breaking list -->

- - - -
- `MetalLookAndFeel`や`MotifLookAndFeel`では、以下のように`MessageDialog`のイベント音の変更が可能

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>UIManager.put("OptionPane.informationSound", "/example/notice2.wav");
</code></pre>

## 参考リンク
- [Swingコンポーネントの音声フィードバック - Java™ SE 1.4でのSwingの変更点および新機能](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/swing/1.4/SwingChanges.html#bug4290988)
- [Merlinの魔術: Swingのオーディオ](https://www.ibm.com/developerworks/jp/java/library/j-mer0730/)
- ["taitai studio" フリーWav素材集](http://www.taitaistudio.com/wav/)
- [Beep音を鳴らす](https://ateraimemo.com/Swing/Beep.html)
- [MIDIファイルの演奏](https://ateraimemo.com/Swing/MidiSystem.html)
- [Wavファイルの演奏](https://ateraimemo.com/Swing/Sound.html)

<!-- dummy comment line for breaking list -->

## コメント
