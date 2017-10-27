---
layout: post
category: swing
folder: MidiSystem
title: MIDIファイルの演奏
tags: [Sound, MidiSystem]
author: aterai
pubdate: 2006-01-09T18:08:23+09:00
description: MidiSystemからSequencerを作成取得し、MIDIファイルを演奏します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTP2Xw5rXI/AAAAAAAAAeo/3v8-ggh9ZBE/s800/MidiSystem.png
comments: true
---
## 概要
`MidiSystem`から`Sequencer`を作成取得し、`MIDI`ファイルを演奏します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTP2Xw5rXI/AAAAAAAAAeo/3v8-ggh9ZBE/s800/MidiSystem.png %}

## サンプルコード
<pre class="prettyprint"><code>URL url = getClass().getResource("Mozart_toruko_k.mid");
final Sequencer sequencer;
try {
  Sequence s = MidiSystem.getSequence(url);
  sequencer  = MidiSystem.getSequencer();
  sequencer.open();
  sequencer.setSequence(s);
} catch (Exception ex) {
  ex.printStackTrace();
  return;
}
startButton = new JButton(new AbstractAction("start") {
  @Override public void actionPerformed(ActionEvent ae) {
    sequencer.start();
  }
});
</code></pre>

## 解説
`MidiSystem.getSequencer`メソッドで`Sequencer`を取得し、これに`MidiSystem.getSequence`メソッドで`MIDI`ファイルから生成した`Sequence`を設定します。

`Sequencer#start()`メソッドで演奏を開始することができます。

## 参考リンク
- [MidiSystem (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/sound/midi/MidiSystem.html)
- [Javaでゲーム - サウンドメモ](http://muimi.com/j/game/sound/)
- [クラシックMIDI ラインムジーク](http://classic-midi.com/)
- [Wavファイルの演奏](http://ateraimemo.com/Swing/Sound.html)
- [Beep音を鳴らす](http://ateraimemo.com/Swing/Beep.html)
- [AuditoryCuesでイベント音を設定する](http://ateraimemo.com/Swing/AuditoryCues.html)

<!-- dummy comment line for breaking list -->

## コメント
