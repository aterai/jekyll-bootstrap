---
layout: post
category: swing
folder: UninstallListeners
title: MouseListenerなどを削除してコンポーネントの入力操作を制限する
tags: [MouseListener, MouseMotionListener, JSlider]
author: aterai
pubdate: 2015-10-05T00:07:30+09:00
description: MouseListenerやMouseMotionListenerなどを削除することで、JSliderへの入力操作を制限します。
comments: true
---
## 概要
`MouseListener`や`MouseMotionListener`などを削除することで、`JSlider`への入力操作を制限します。

{% download https://lh3.googleusercontent.com/-R8lyg28qxOc/VhE8l7UdVnI/AAAAAAAAODQ/XDVHIbj2uyY/s800-Ic42/UninstallListeners.png %}

## サンプルコード
<pre class="prettyprint"><code>JSlider slider3 = new JSlider(0, 100, 50) {
  @Override public void updateUI() {
    super.updateUI();
    setFocusable(false); //uninstallKeyboardActions
    for (MouseListener l: getMouseListeners()) {
      removeMouseListener(l);
    }
    for (MouseMotionListener l: getMouseMotionListeners()) {
      removeMouseMotionListener(l);
    }
    //removeFocusListener(focusListener);
    //removeComponentListener(componentListener);
    //removePropertyChangeListener( propertyChangeListener );
    //getModel().removeChangeListener(changeListener);
  }
};
</code></pre>

## 解説
1. デフォルトの`JSlider`
1. `JSlider#setEnabled(false)`で無効化
    - 表示が変更されて(灰色)、無効状態をユーザーにフィードバック

<!-- dummy comment line for breaking list -->
1. `BasicSliderUI#uninstallListeners(...)`、`BasicSliderUI#uninstallKeyboardActions(...)`メソッドをリフレクションでアクセス可能に変更して実行
    - 参考: [JSlider Problem | Oracle Community](https://community.oracle.com/threads/1360123)
    - 無効状態ではないので、ノブなどが灰色にならない
    - `ComponentListener`なども削除されるので、リサイズしても表示は不変

<!-- dummy comment line for breaking list -->
1. `getMouseListeners()`などで取得したリスナーを削除
    - `MouseListener`と`MouseMotionListener`を削除
    - キー入力は、`setFocusable(false)`で無効化(`InputMap`には、`JComponent.WHEN_FOCUSED`で登録されているのでフォーカスがなければキー入力できない)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSlider Problem | Oracle Community](https://community.oracle.com/threads/1360123)
- [JLayerで子コンポーネントへの入力を制限する](http://ateraimemo.com/Swing/PopupMenuBlockLayer.html)
    - `JDK 1.7.0`以降なら、`JLayer`で入力をマスクすることが可能

<!-- dummy comment line for breaking list -->

## コメント