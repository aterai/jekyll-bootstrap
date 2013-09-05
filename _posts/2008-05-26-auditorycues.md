---
layout: post
title: AuditoryCuesでイベント音を設定する
category: swing
folder: AuditoryCues
tags: [UIManager, AuditoryCues, Sound, JOptionPane]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-05-26

## AuditoryCuesでイベント音を設定する
`UIManager`に`AuditoryCues.playList`を設定して、ダイアログが開いた時の警告音などを鳴らします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTHzQ8XbXI/AAAAAAAAARw/-TGnQ_tvnnM/s800/AuditoryCues.png)

### サンプルコード
<pre class="prettyprint"><code>Object[] optionPaneAuditoryCues = {
  "OptionPane.errorSound", "OptionPane.informationSound",
  "OptionPane.questionSound", "OptionPane.warningSound"
};
//UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.allAuditoryCues"));
//UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.defaultCueList"));
//UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.noAuditoryCues"));
UIManager.put("AuditoryCues.playList", optionPaneAuditoryCues);
</code></pre>

### 解説
上記のサンプルでは、デフォルトではすべて再生しないように設定されている聴覚フィードバックを、`JOptionPane`でダイアログを開いた時には有効になるように変更しています。

- `showMessageDialog1`
    - `LookAndFeel`デフォルトの音が鳴る(`LookAndFeel`にデフォルトの音が無い場合は鳴らない)
    - `WindowsLookAndFeel`では、「コントロールパネル」「サウンドとオーディオデバイスのプロパティ」で、プログラムイベントが設定されている場合は鳴る

<!-- dummy comment line for breaking list -->

- `showMessageDialog2`
    - `wav`ファイルで音を鳴らす
    - `UIManager.put("AuditoryCues.playList", UIManager.get("AuditoryCues.noAuditoryCues"))`として、二重に鳴らないようにしている

<!-- dummy comment line for breaking list -->

- - - -
`MetalLookAndFeel`や`MotifLookAndFeel`では、以下のようにすることで、`MessageDialog`のイベント音を変更することも出来ます。

<pre class="prettyprint"><code>UIManager.put("OptionPane.informationSound", "/example/notice2.wav");
</code></pre>

### 参考リンク
- [Swing コンポーネントの音声フィードバック](http://docs.oracle.com/javase/jp/6/technotes/guides/swing/SwingChanges.html#Miscellaneous)
- [Merlinの魔術: Swingのオーディオ](http://www.ibm.com/developerworks/jp/java/library/j-mer0730/)
- ["taitai studio" フリーWav素材集](http://www.taitaistudio.com/wav/)
    - wavファイルを拝借しています。
- [Beep音を鳴らす](http://terai.xrea.jp/Swing/Beep.html)
- [MIDIファイルの演奏](http://terai.xrea.jp/Swing/MidiSystem.html)
- [Wavファイルの演奏](http://terai.xrea.jp/Swing/Sound.html)

<!-- dummy comment line for breaking list -->

### コメント