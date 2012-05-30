#!nqp
use MASTTesting;

plan(2);

mast_frame_output_is(-> $frame {
        my $r0 := MAST::Local.new(:index($frame.add_local(int)));
        my $l1 := MAST::Label.new(:name('foo'));
        my @ins := $frame.instructions;
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('const_i64'),
                $r0,
                MAST::IVal.new( :value(1) )
            ));
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('goto'),
                $l1
            ));
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('const_i64'),
                $r0,
                MAST::IVal.new( :value(0) )
            ));
        nqp::push(@ins, $l1);
        nqp::push(@ins, MAST::Op.new(
                :bank('dev'), :op('say_i'),
                $r0
            ));
        nqp::push(@ins, MAST::Op.new( :bank('primitives'), :op('return') ));
    },
    "1\n",
    "unconditional forward branching");

mast_frame_output_is(-> $frame {
        my $r0 := MAST::Local.new(:index($frame.add_local(int)));
        my $l1 := MAST::Label.new(:name('foo'));
        my $l2 := MAST::Label.new(:name('bar'));
        my @ins := $frame.instructions;
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('const_i64'),
                $r0,
                MAST::IVal.new( :value(1) )
            ));
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('goto'),
                $l1
            ));
        # Next instruction deliberately unreachable.
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('const_i64'),
                $r0,
                MAST::IVal.new( :value(3) )
            ));
        nqp::push(@ins, $l2);
        nqp::push(@ins, MAST::Op.new(
                :bank('dev'), :op('say_i'),
                $r0
            ));
        nqp::push(@ins, MAST::Op.new( :bank('primitives'), :op('return') ));
        nqp::push(@ins, $l1);
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('const_i64'),
                $r0,
                MAST::IVal.new( :value(2) )
            ));
        nqp::push(@ins, MAST::Op.new(
                :bank('primitives'), :op('goto'),
                $l2
            ));
    },
    "2\n",
    "unconditional forward and backward branching");
