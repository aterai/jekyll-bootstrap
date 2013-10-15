---
layout: post
title: MIDIファイルの演奏
category: swing
folder: MidiSystem
tags: [Sound, MidiSystem]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-01-09

## MIDIファイルの演奏
`MidiSystem`から`Sequencer`を作成取得し、`MIDI`ファイルを演奏します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTP2Xw5rXI/AAAAAAAAAeo/3v8-ggh9ZBE/s800/MidiSystem.png)

### サンプルコード
<pre class="prettyprint"><code>URL url = getClass().getResource("Mozart_toruko_k.mid");
final Sequencer sequencer;
try{
  Sequence s = MidiSystem.getSequence(url);
  sequencer  = MidiSystem.getSequencer();
  sequencer.open();
  sequencer.setSequence(s);
}catch(Exception ex) {
  ex.printStackTrace();
  return;
}
start = new JButton(new AbstractAction("start") {
  @Override public void actionPerformed(ActionEvent ae) {
    sequencer.start();
  }
});
</code></pre>

### 解説
`MidiSystem.getSequencer`メソッドで`Sequencer`を取得し、これに`MidiSystem.getSequence`メソッドで`MIDI`ファイルから生成した`Sequence`を設定します。

`Sequencer.start`メソッドで演奏を開始することができます。

### 参考リンク
- [Javaでゲーム - サウンドメモ](http://muimi.com/j/game/sound/)
- [クラシックMIDI ラインムジーク](http://classic-midi.com/)
- [Wavファイルの演奏](http://terai.xrea.jp/Swing/Sound.html)
- [Beep音を鳴らす](http://terai.xrea.jp/Swing/Beep.html)
- [AuditoryCuesでイベント音を設定する](http://terai.xrea.jp/Swing/AuditoryCues.html)

<!-- dummy comment line for breaking list -->

### コメント
