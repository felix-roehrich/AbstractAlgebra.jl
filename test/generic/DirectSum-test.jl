@testset "Generic.DirectSum.constructors" begin
   for R in [ZZ, QQ]
      for iter = 1:100
         num = rand(1:5)
         M = [rand_module(R, -10:10) for i in 1:num]
         D, f, g = direct_sum(M)

         @test isa(D, Generic.DirectSumModule)
      end
   end

   F = free_module(ZZ, 2)
   m = F(BigInt[1, 0])
   n = F(BigInt[0, 1])
   S, f = sub(F, [m, n])
   Q, g = quo(F, S)
   D, h = direct_sum(Q)
   m = D([])

   @test isa(m, Generic.DirectSumModuleElem)

   F = free_module(QQ,2)
   D, inj, pro = direct_sum(F, F)
   f = D([gen(F, 1), gen(F,2)])
   @test rank(D) == 4
   @test gen(D, 1) == D[1]
   @test isa(f, Generic.DirectSumModuleElem)
   @test f == inj[1](gen(F,1)) + inj[2](gen(F, 2))

   @test_throws ArgumentError gen(D, 0)
   @test_throws ArgumentError gen(D, ngens(D) + 1)
end

@testset "Generic.DirectSum.basic_manipulation" begin

   for R in [ZZ, QQ]
      for iter = 1:100
         num = rand(1:5)
         M = [rand_module(R, -10:10) for i in 1:num]

         D, f, g = direct_sum(M...)

         @test summands(D) == M
      end
   end
end

@testset "Generic.DirectSum.maps" begin
   for R in [ZZ, QQ]
      for iter = 1:100
         num = rand(1:5)
         M = [rand_module(R, -10:10) for i in 1:num]

         D, f, g = direct_sum(M)

         m = [rand(M[i], -10:10) for i in 1:num]

         for i = 1:num
            @test g[i](f[i](m[i])) == m[i]
            @test canonical_projection(D, i)(canonical_injection(D, i)(m[i])) == m[i]
         end
      end
   end

   F = free_module(QQ, 2)
   D, _ = direct_sum(F, F)
   p = ModuleHomomorphism(F, F, [1, 2] .* gens(F))
   q = ModuleHomomorphism(F, F, [3, 4] .* gens(F))
   phi = ModuleHomomorphism(D, D, [p 0; q q])

   @test phi(gen(D, 1)) == D([p(gen(F, 1)), zero(F)])
   @test phi(gen(D, 2)) == D([p(gen(F, 2)), zero(F)])
   @test phi(gen(D, 3)) == D([q(gen(F, 1)), q(gen(F, 1))])
   @test phi(gen(D, 4)) == D([q(gen(F, 2)), q(gen(F, 2))])

end

@testset "Generic.DirectSum.isomorphism" begin
   for R in [ZZ, QQ]
      for iter = 1:100
         num = rand(1:5)
         M = [rand_module(R, -10:10) for i in 1:num]

         D1, f, g = direct_sum(M)

         D2, f, g = direct_sum(shuffle(M))

         @test is_isomorphic(D1, D2)
      end
   end
end

